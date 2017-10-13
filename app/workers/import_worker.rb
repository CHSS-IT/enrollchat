class ImportWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(filepath, user_id)
    user = User.find(user_id)
    ActionCable.server.broadcast 'room_channel',
                                 body:  "Registration data import in process.",
                                 section_name: "Alert",
                                 user: "System"
    Section.import(filepath)
    puts @report


  end
end