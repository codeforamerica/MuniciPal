require 'legistar'

namespace :legistar_attachments do
  desc "Load Legistar attachments into database (for all matters, or a particular matter_id)"
  task :load, [:matter_id] => [:environment] do |t, args|
    Legistar.initialize()

    if args and args.matter_id
      # puts "fetching attachments for matter_id: #{args.matter_id}"
      Legistar.fetch_nested_collection('Attachments', nil, 'MatterAttachment', MatterAttachment, 'Matters', Matter, [Matter.find(args.matter_id)])
    else
      # puts "fetching all attachments"
      Legistar.fetch_nested_collection('Attachments', nil, 'MatterAttachment', MatterAttachment, 'Matters', Matter)
    end
  end


  desc "Display structure of any REST endpoint"
  task :structure, [:url, :prefix_to_strip] => [:environment] do |t, args|
    Legistar.initialize()
    Legistar.fetch_structure(args.url, args.prefix_to_strip)
  end

  desc "Empty legistar attachments table"
  task :drop => :environment  do
    MatterAttachment.destroy_all
  end
end
