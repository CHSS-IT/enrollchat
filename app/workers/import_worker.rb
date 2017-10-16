class ImportWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(filepath, user_id)
    user = User.find(user_id)
    Section.import(filepath)
    puts @report


  end
end