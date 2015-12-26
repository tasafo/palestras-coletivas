Airbrake.configure do |config|
  config.api_key = ENV['AIRBRAKE_API_KEY']
  #config.project_id = ENV['AIRBRAKE_PROJECT_ID']
  #config.ignore_environments = %w(development test)
end
