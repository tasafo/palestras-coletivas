worker_processes 3
timeout 30
preload_app true

before_fork do |server, worker|
  @sidekiq_pid ||= spawn("bundle exec sidekiq -C ./config/sidekiq.yml")
end

after_fork do |server, worker|
  Sidekiq.configure_client do |config|
    config.redis = { :size => 1 }
  end

  Sidekiq.configure_server do |config|
    config.redis = { :size => 5 }
  end
end
