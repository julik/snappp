# snappp

Grab captured screenshots on OSX and upload them to your S3 bucket. Copy the URL of the uploaded
screenshot to the clipboard.

## Usage

Start the app in the terminal and just let it run. Or start it using launchd (you will need to go
through a few hoops for this when using rbenv/rvm though).

    $ ./bin/snappp

## Configuration

You need the following envvars (they can be set from .env):

* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY
* AWS_BUCKET_NAME
* AWS_REGION

Please use a restricted user.

## Contributing to snappp
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2016 Julik Tarkhanov. See LICENSE.txt for
further details.

