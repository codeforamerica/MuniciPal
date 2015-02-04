[![Stories in Ready](https://badge.waffle.io/codeforamerica/municipal.png?label=ready&title=Ready)](https://waffle.io/codeforamerica/municipal)

# [Municipal](https://github.com/codeforamerica/MuniciPal)

Consulting city-dwellers about legislation near them.

Created for the city of Mesa, AZ. Please feel free to [post](https://github.com/codeforamerica/MuniciPal/issues/new) in the ["Issues" section](https://github.com/codeforamerica/MuniciPal/issues) with any questions or comments.

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

## Installation instructions

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
        bundle exec rake app:deploy

6. Edit your deployment-specific configuration. For dev/test environments, copy the file `.env.sample` to `.env` and edit the configuration settings in it. For Heroku production environments, the configuration can be set with `heroku config` or via the app dashboard (tip: add the `heroku-config` plugin and you can run `heroku config:push -i` to push all your .env variables, interactively; see [heroku's configuration documentation](https://devcenter.heroku.com/articles/config-vars) for details). If you are deploying via the 'Deploy to Heroku' button, you'll be able to set the configuration during the deployment process through a web form. 

#### Run your application

        rails server

#### You did it!

Now you can access your application at http://0.0.0.0:3000

#### Notes on loading your own Council Districts:

The map component of this application is based around Mesa's Council Districts. It searches through legislative text for Districts and then associates them with those districts so that they can be pulled up through the map and through address search.

More information about where we get the district boundaries can be found [on the wiki](https://github.com/codeforamerica/MuniciPal/wiki/Getting-Council-Data).

#### Notes on deploying to heroku:

Deploy automatically:

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

Or deploy manually:

        heroku create
        heroku config:set BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git
        heroku addons:add heroku-postgresql:hobby-dev
        heroku pg:info
        git push heroku master
        heroku run bundle exec rake app:deploy

#### Keeping your Legistar agenda items up to date

Running `rake legistar_all:refresh` (locally), or `heroku run rake legistar_all:refresh` on heroku will fetch the recent agenda items. You may also want to learn how to [schedule Legistar updates on Heroku](https://github.com/codeforamerica/MuniciPal/wiki/Scheduling-Legistar-Updates-on-Heroku).

#### Further documentation

Please see the [wiki](https://github.com/codeforamerica/MuniciPal/wiki).

## Tests

Current tests [may be stale](https://github.com/codeforamerica/MuniciPal/issues/110).

## Copyright

Copyright (c) 2014 Code for America. BSD License.
Based on [sa-zone](https://github.com/codeforamerica/sa-zone), created by Amy Mok, Maya Benari, and David Leonard.
Significantly modified by Peter Welte, Tom Buckley, Andrew Douglas, and Wendy Fong.
