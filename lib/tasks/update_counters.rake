namespace :db do
  namespace :pc do
    desc 'Updates counters from users, talks, events and schedules'
    task update_counters: :environment do
      puts 'Updating users counters...'

      User.all.each do |user|
        user.counter_public_talks = user.talks.where(to_public: true).count
        user.counter_watched_talks = user.watched_talks.count
        user.counter_organizing_events = user.events.publics.count
        user.counter_presentation_events = user.talks.select(&:schedules?).sum { |talk| talk.schedules.count }
        user.counter_enrollment_events = user.enrollments.actives.count
        user.counter_participation_events = user.enrollments.presents.count
        user.save
      end

      puts 'Updating talks counters...'

      Talk.all.each do |talk|
        talk.update(counter_presentation_events: talk.schedules.count)
      end

      puts 'Updating events counters...'

      Event.all.each do |event|
        event.update(counter_registered_users: event.enrollments.actives.count,
                     counter_present_users: event.enrollments.presents.count)
      end

      puts 'Updating schedules counters...'

      Schedule.all.each do |schedule|
        schedule.update(counter_votes: schedule.votes.count)
      end
    end
  end
end
