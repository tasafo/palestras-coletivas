namespace :db do
  namespace :pc do
    desc "Updates the counters user"
    task :update_user_counters => :environment do
      users = User.all
      users.each do |user|
        user.counter_public_talks = user.talks.where(:to_public => true).count
        user.save
      end
    end
  end
end