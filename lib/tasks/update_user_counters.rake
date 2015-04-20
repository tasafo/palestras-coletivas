namespace :db do
  namespace :pc do
    desc "Updates the user counters"
    task :update_user_counters => :environment do
      User.all.each do |user|
        user.counter_public_talks = user.talks.where(:to_public => true).count
        user.counter_watched_talks = user.watched_talks.count
        user.save
      end
    end
  end
end