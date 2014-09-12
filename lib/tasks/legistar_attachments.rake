namespace :legistar_attachments do
  desc "Load Legistar attachments into database (by finding from each event_item)"
  task :load => :environment do
    Legistar.initialize()
    Legistar.fetch_nested_collection('Attachments', nil, 'MatterAttachment', MatterAttachment, 'Matters', Matter)
  end

  desc "Empty legistar attachments table"
  task :drop => :environment  do
    MatterAttachment.destroy_all
  end
end
