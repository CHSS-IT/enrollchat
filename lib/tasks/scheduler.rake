desc "This task is called by the Heroku scheduler add-on"
task :purge_deleted => :environment do
  puts "Deleting marked sections..."
  Section.delete_marked
  puts "done."
end