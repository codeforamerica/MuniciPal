# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Zone::Application.initialize!

# http://stackoverflow.com/questions/23794276/rails-render-json-object-with-camelcase
Jbuilder.key_format camelize: :lower

