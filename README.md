# Update 12/6/2015
We're no longer developing or maintaining this codebase. If you want to learn more or have any questions feel free to get in touch with the original team:
- [@lippytak](http://twitter.com/lippytak/)
- [@allafarce](http://twitter.com/allafarce/)
- [@alanjosephwilli](http://twitter.com/alanjosephwilli/)

# CalFresh and So Clean

[![Build Status](https://travis-ci.org/codeforamerica/clean.svg?branch=make-all-tests-pass)](https://travis-ci.org/codeforamerica/clean)

Making applying to the CalFresh program not suck.

## How it sucks now

If you want to understand the genesis of the project, [click here](https://github.com/codeforamerica/health-project-ideas/issues/6).

[Click here to experience what it's like to apply to CalFresh right now.](http://codeforamerica.github.io/citizen-onboard/calfresh/)

## What's this?

A user-friendly web form with the minimal fields necessary that generates a PDF application and faxes it in to HSA.

## Local setup

- [Install Ruby version 2.1.5](https://github.com/codeforamerica/howto/blob/master/Ruby.md)
- Install system dependencies `pdftk` and `imagemagick` (use Homebrew on OSX or apt-get on Debian/Ubuntu)
- Install Redis with `brew install redis`
- Install Ruby dependencies with `bundle install`

Set the environment variable `REDISTOGO_URL` to `redis://localhost:6379` and start your local Redis server with `redis-server`

This app uses the Postgres database, so make sure that is running locally when you start your app up. (We recommend using Postgres.app on OSX.) Set the POSTGRES_USERNAME and POSTGRES_PASSWORD environment variables for your local Postgres database.

Then, create the databases for the app by running:

```
bundle exec rake db:create
```

You can now run the app by running:

```
rails s
```

and navigating in your browser to [http://localhost:1234](http://localhost:1234)

For email capabilities we use Sendgrid, so for that set the following environment variables:

- `SENDGRID_USERNAME`
- `SENDGRID_PASSWORD`
- `EMAIL_ADDRESS_TO_SEND_TO`

We also password protect the output application in a ZIP file and you can set the password with the `ZIP_FILE_PASSWORD` environment variable.

To run tests, run:

```
rake spec
```

## SSL

If `RACK_ENV` is set to anything other than the default (`development`) then all unencrypted HTTP requests will be redirected to their HTTPS equivalents.

Put another way: when developing locally, you should be good to go. If you're deploying, you will need to configure SSL (works by default on Heroku if you're using their default XXX.herokuapp.com domain for your app).

## Deployment to Heroku

```bash
heroku create YOURAPPNAMEGOESHERE
heroku config:add BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git
git push heroku master
heroku config:set PATH=/app/bin:/app/vendor/bundle/bin:/app/vendor/bundle/ruby/2.1.0/bin:/usr/local/bin:/usr/bin:/bin:/app/vendor/pdftk/bin
heroku config:set LD_LIBRARY_PATH=/app/vendor/pdftk/lib
```

## Metrics on production deployment
Our primary metrics are:
- # of approved applications (quantity)
- % of submitted applications approved (quality)

[![Metrics](https://plot.ly/~lippytak/189.png)](http://keep-it-clean-metrics.herokuapp.com/)

(# of submitted apps shown for context)

## Copyright and License

Copyright 2014 Dave Guarino
MIT License
