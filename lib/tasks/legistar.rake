namespace :legistar do
  desc "Wipe our database, then rebuild it by recopying content via Legistar API"
  task :refresh => [:drop, :load] do
  end

  desc "Wipe our database of all Legistar-based contents"
  task :drop => ['legistar_events:drop', 'legistar_event_items:drop', 'legistar_matters:drop'] do
  end

  desc "Copy all Legistar content into local database using Legistar API"
  task :load => ['legistar_events:load', 'legistar_event_items:load', 'legistar_matters:load'] do
  end
end


#TODO: also depend on geocoding everything.