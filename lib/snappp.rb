require 'rb-fsevent'
require 'aws-sdk'
require 'terminal-notifier'
require 'clipboard'
require 'thread'

module Snappp
  WATCH_WHERE = File.join(ENV.fetch('HOME'), 'Desktop')
  FILE_PATTERNS = ['Screen Shot *.*', 'Screenshot *.*']
  UPLOADERS = 3
  
  def self.upload_screenshot(screenie_path)
    b = Aws::S3::Bucket.new(ENV.fetch('AWS_BUCKET_NAME'))
    s3_obj = b.object(File.basename(screenie_path))
  
    File.open(screenie_path, 'rb') do |f|
      s3_obj.put(body: f, acl: 'public-read', storage_class: 'REDUCED_REDUNDANCY')
    end
  
    public_url = s3_obj.public_url
    
    $stderr.puts "Uploaded #{public_url}"
    
    Clipboard.copy(public_url)
    TerminalNotifier.notify('Sent %s' % File.basename(screenie_path), :title => 'snappp', :open => public_url)
    
    File.unlink(screenie_path)
  end
  
  def self.run
    q = Queue.new
    (1..UPLOADERS).map do
      Thread.new do
        loop do 
          begin
            path = q.pop(non_block=true)
            pid = fork { upload_screenshot(path) }
            Process.wait(pid)
          rescue ThreadError
            sleep 2
          end
        end
      end
    end
    
    fsevent = FSEvent.new
    fsevent.watch(File.dirname(WATCH_WHERE), :file_events => true) do |paths|
      
      screenies = paths.select{|path| File.exist?(path) }.select do | path |
        File.size(path) > 0
      end.select do | path |
        FILE_PATTERNS.any?{|pattern| File.fnmatch(pattern, File.basename(path))}
      end
      
      screenies.each { |screenie_path| q << screenie_path }
    end
    
    fsevent.run
  end
end
