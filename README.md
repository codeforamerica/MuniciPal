[![Stories in Ready](https://badge.waffle.io/codeforamerica/municipal.png?label=ready&title=Ready)](https://waffle.io/codeforamerica/municipal)
# Municipal

Consulting city-dwellers about legislation near them.

Created for the city of Mesa, AZ. Please feel free to post in the "Issues" section with any questions or comments.

# Prerequisites

* This application requires Ruby. If you don't have it, [download and install here](https://www.ruby-lang.org/en/installation/).
* This application requires Rails.
* This application also requires Postgres SQL. If you don't have it, [download and install here](http://postgresapp.com/).
* This application also requires PostGIS.

# Installation instructions

#### Clone the app to your machine:

    git clone
    cd MuniciPal

#### Install the dependencies:

    bundle install

#### Create the database:

    bundle exec rake db:create
    bundle exec rake db:migrate
    bundle exec rake legistar_all:load
    bundle exec rake council_districts:load

*If you want to update or change these specific shapefiles, they exist in the lib/asset folder in the application.*

#### Run your application

    rails server

#### Troubleshooting

Make sure the postgis extension is properly loaded.

    SELECT POSTGIS_VERSION(); # succeeds if PostGIS objects are present.

#### You did it!

Now you can access your application at http://0.0.0.0:3000

#### Notes on loading your own Boundary Data:

The council_districts:load rake task loads a "Councils.shp" file in the Mesa/assets directory.

The EPSG for this shapefile must be 4326. 

#### Notes on deploying to heroku:

    heroku create
    heroku config:set BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git
    heroku addons:add heroku-postgresql:standard-tengu
    heroku pg:info
    heroku pg:promote NAME_OF_DATABASE
    git push heroku master
    heroku run rake db:migrate
    heroku run bundle exec rake mesa_councils:load
    heroku run bundle exec rake legistar_events:load
    heroku run bundle exec rake legistar_event_items:load
    heroku run bundle exec rake legistar_event_items:load
    heroku run bundle exec rake legistar_event_items_districts:load

# Copyright

Copyright (c) 2014 Code for America. BSD License.
Based sa-zone, created by Amy Mok, Maya Benari, and David Leonard.
Significantly modified by Peter Welte, Tom Buckley, Andrew Douglas, and Wendy Fong.
