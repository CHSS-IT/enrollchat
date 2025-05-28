Bugsnag.configure do |config|
  config.api_key = ENV['BUGSNAG_API_KEY']
  config.meta_data_filters += ['extra_attributes', 'ticket', '_csrf_token']
  config.notify_release_stages = ["production"]
end
