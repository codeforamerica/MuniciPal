[![Stories in Ready](https://badge.waffle.io/codeforamerica/municipal.png?label=ready&title=Ready)](https://waffle.io/codeforamerica/municipal)
# Municipal

Consulting city-dwellers about legislation near them.

Created for the city of Mesa, AZ. Please feel free to post in the "Issues" section with any questions or comments.

# Installation instructions

Municipal is a Ruby on Rails application using PostgreSQL and PostGIS.

1. Begin by installing [Ruby](https://github.com/codeforamerica/howto/blob/master/Ruby.md) and [PostgreSQL](https://github.com/codeforamerica/howto/blob/master/PostgreSQL.md) for your system.
    
    You will also need a javascript runtime such as [Node](https://github.com/codeforamerica/howto/blob/master/Node.js.md) for use by `bundle`, and PostGIS for database geo features. On Mac, these may already be installed with the base system and Postgres.app. On Ubuntu Linux, they can be installed with:
    
        apt-get install nodejs postgresql-9.3-postgis-2.1
    
2. Create a PostgreSQL user with super-user privileges (`createdb --superuser`) and a name matching that of your user account (`whoami`).
3. Clone MuniciPal to your local server:
    
        git clone https://github.com/codeforamerica/MuniciPal.git
        cd MuniciPal
    
4. Install Ruby dependencies:
    
        bundle install
    
5. Create the database:

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
        heroku run rake legistar_all:load
        heroku run rake council_districts:load

# Copyright

Copyright (c) 2014 Code for America. BSD License.
Based on [sa-zone](https://github.com/codeforamerica/sa-zone), created by Amy Mok, Maya Benari, and David Leonard.
Significantly modified by Peter Welte, Tom Buckley, Andrew Douglas, and Wendy Fong.
