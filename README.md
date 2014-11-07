[![Stories in Ready](https://badge.waffle.io/codeforamerica/municipal.png?label=ready&title=Ready)](https://waffle.io/codeforamerica/municipal)

# Municipal

Consulting city-dwellers about legislation near them.

Created for the city of Mesa, AZ. Please feel free to post in the "Issues" section with any questions or comments.

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

# Prerequisites

* This application requires Ruby. If you don't have it, [download and install here](https://www.ruby-lang.org/en/installation/).
* This application requires Rails.
* This application also requires Postgres SQL. If you don't have it, [download and install here](http://postgresapp.com/).

# Installation instructions

#### Clone the app to your machine:

    git clone
    cd MuniciPal

#### Install the dependencies:

    bundle install

#### Create the database:

    bundle exec rake db:create
    bundle exec rake app:deploy

*If you want to update or change these specific shapefiles, they exist in the lib/asset folder in the application.*

#### Run your application

    rails server

#### Troubleshooting

Make sure the postgis extension is properly loaded.

    SELECT POSTGIS_VERSION(); # succeeds if PostGIS objects are present.

#### You did it!

Now you can access your application at http://0.0.0.0:3000

#### Notes on loading your own Council Districts:

The map component of this application is based around Mesa's Council Districts. It searches through legislative text for Districts and then associates them with those districts so that they can be pulled up through the map and through address search. 

#### Notes on deploying to heroku:

Deploy automatically:

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

Or deploy manually:

	heroku create
	heroku config:set BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git
	heroku addons:add heroku-postgresql:standard-0
	heroku pg:info
	git push heroku master
	heroku run bundle exec rake app:deploy

##Tests
 Current tests may be stale.

# Copyright

Copyright (c) 2014 Code for America. BSD License.
Based sa-zone, created by Amy Mok, Maya Benari, and David Leonard.
Significantly modified by Peter Welte, Tom Buckley, Andrew Douglas, and Wendy Fong.
