class ImportWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(filepath, user_id)
    user = User.find(user_id)
    ActionCable.server.broadcast 'room_channel',
                                 body:  "Registration data import in process.",
                                 section_name: "Alert",
                                 user: user.username
    Section.import(filepath)
    puts @report
    ActionCable.server.broadcast 'room_channel',
                                 body:  "Registration data import complete.",
                                 section_name: "Alert",
                                 user: user.username

  end
end