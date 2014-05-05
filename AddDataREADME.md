How to add new shapefiles
=============

### Check out the attributes in QGis/CartoDB

This will let you see the attributes of your data.

### Put shapefile data folder into lib/assets

### Create a rake tast

NEED TO COMPLETE DOCUMENT. Rake task is stored in lib/assets/tasks.

### Create a model

(NOTE: Class has to be singular.) Create a new model in app/models/

### Create a migration

First, generate a migration with Rails by running this command in your shell:

    rails generate migration YourMigrationName

This will generate a migration file in app/db/migrate that is timestamped. Now populate this file with the appropriate field information

ADD IN THAT STUFF HERE

### Now, run the bundle exec command

    bundle exec rake db:migrate

Awesome! This will create a new, empty table with the appropriate column headers. Next up, we will populate that table. If you want to see if this worked, you can run these commands.

    rails console

    YourModelName.column_names

Looking good.

### Load the data into your shiny new table

    bundle exec rake your_rake_name:load

### Test your new table

Find a lat/long that you know is inside one of your new polygons and test it.

    rails console
    YourModelName.inDistrict? lat, long

If everything goes correctly, and that lat/long corresponds to a polygon in your new table, then you should get "true".

Now you can actually pull some information out of the table based on that lat, long. Still in your rails console, try:

    YourModelName.getDistrict lat, long

Want to try the false case? Give it any lat, long you know isn't in a polygon in your table. In the rails console:

    YourModelName.inDistrict? lat, long

### Time to make a controller. 

Open up app/controllers/addresses_controller.rb

NOW DESCRIBE HOW TO ADD THIS JUNK.

Let's check and see if this worked. Go ahead and find an address that you know is inside your new polygon. 

### 

