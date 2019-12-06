namespace :user_reset do
  desc "Resets the active_session attribute to false. Protects user stat integretity by covering edge case where a user might logout by non-standard means - deleting cookie, appending /logout to url"
  include Rake::DSL

  task :active_session => :environment do
    users = User.all
    users.each do |user|
      if user.active_session
        user.active_session = false
        user.save(touch: false)
      end
    end
  end
end