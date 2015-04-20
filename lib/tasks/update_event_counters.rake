namespace :db do
  namespace :pc do
    desc "Updates the event counters"
    task :update_event_counters => :environment do
      Event.all.each do |event|
        event.counter_registered_users = event.enrollments.actives.count
        event.counter_present_users = event.enrollments.presents.count
        event.save
      end
    end
  end
end