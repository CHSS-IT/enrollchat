namespace :import do

  include Rake::DSL

  task :bulletproof => :environment do
    puts "Start"
    Dir.glob("#{Rails.root}/doc/*.csv").each do |f|
      text = File.read(f)
      old_text = File.read(f)
      new_contents = text.gsub(/(?<!^)(?<!,)"(?!,|\R)/, "'")
      # To merely print the contents of the file, use:
      puts new_contents

      # To write changes to the file, use:
      File.open(f, "w") {|file| file.write new_contents }


      if new_contents != old_text
        report_action(chss,"CSV Correction","Bulletproof task made changes to #{f}.")
      end
    end
    puts "Finish"
  end


  task :retrieve_files => :environment do
    require 'net/ssh'
    require 'net/sftp'

  end


  task :sections => :environment do
    ActionCable.server.broadcast 'room_channel',
                                 message:  "<a href='/sections' class='dropdown-item'>Registration data import in process.</a>"
    path = "#{Rails.root}/doc/test/SemesterEnrollments.csv"
    ImportWorker.perform_async("#{path}")

  end

end