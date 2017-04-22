require 'legistar'

namespace :legistar_all do
  desc "Wipe our database, then rebuild it by recopying content via Legistar API"
  task :refresh => [:drop, :load] do
  end

  desc "Wipe our database of all Legistar-based contents"
  task :drop => ['legistar_events:drop', 'legistar_event_items:drop', 'legistar_matters:drop', 'legistar_attachments:drop'] do
  end

  desc "Copy all Legistar content into local database using Legistar API"
  task :load => ['legistar_events:load', 'legistar_event_items:load', 'legistar_matters:load', 'legistar_attachments:load'] do
  end

  desc "Copy a specific Legistar content into our local database with the new ETL magic"
  task :load_one, [:endpoint, :filter, :prefix_to_strip, :class] => [:environment] do |t, args|
    Legistar.initialize()
    Legistar.fetch_collection(args.endpoint, args.filter, args.prefix_to_strip, Object.const_get(args.class))
  end

  desc "Display structure of any REST endpoint"
  task :structure, [:url, :prefix_to_strip] => [:environment] do |t, args|
    Legistar.fetch_structure(args.url, args.prefix_to_strip)
  end

  desc "Display Legistar stats (number of items in each database table)"
  task :stats => ['legistar_stats:print'] do
  end
end
