require 'legistar'

namespace :legistar_stats do
  desc "Display Legistar stats (number of items in each database table)"
  task :print => :environment do

    dev_null = Logger.new("/dev/null")
    # Rails.logger = dev_null
    ActiveRecord::Base.logger = dev_null
    # Log to /dev/null to get rid of database output like
    # (0.6ms)  SELECT COUNT(*) FROM "matter_attachments"
    # http://stackoverflow.com/a/5783955/1024811

    models = [CouncilDistrict, Matter, MatterAttachment, Event, EventItem]
    total = 0
    models.each do |model|
      count = model.count
      total += count
      puts "#{model.name}: #{count}"
    end

    puts "Total databases rows: #{total}"
  end
end
