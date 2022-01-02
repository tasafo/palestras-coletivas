namespace :db do
  namespace :pc do
    desc 'Updates counters from users, talks, events and schedules'
    task update_counters: :environment do
      batch_size = ENV.fetch('BATCH_SIZE', 50)

      query = User.with_relations.batch_size(batch_size).all
      count = query.count

      query.each_with_index do |user, index|
        puts "Updating user counters #{index + 1}/#{count}"

        user.counter_public_talks = user.talks.publics.count
        user.counter_watched_talks = user.watched_talks.count
        user.counter_organizing_events = user.events.publics.count
        user.counter_presentation_events = user.talks.select(&:schedules?)
                                               .sum { |talk| talk.schedules.presenteds.count }
        user.counter_enrollment_events = user.enrollments.actives.count
        user.counter_participation_events = user.enrollments.presents.count
        user.save
      end

      query = Talk.includes(:users, :schedules).batch_size(batch_size).all
      count = query.count

      query.each_with_index do |talk, index|
        puts "Updating talk counters #{index + 1}/#{count}"

        talk.update(counter_presentation_events: talk.schedules.presenteds.count)
      end

      count = Event.all.count

      Event.batch_size(batch_size).all.each_with_index do |event, index|
        puts "Updating event counters #{index + 1}/#{count}"

        event.update(counter_registered_users: event.enrollments.actives.count,
                     counter_present_users: event.enrollments.presents.count)
      end

      count = Schedule.all.count

      Schedule.batch_size(batch_size).all.each_with_index do |schedule, index|
        puts "Updating schedule counters #{index + 1}/#{count}"

        schedule.update(counter_votes: schedule.votes.count)
      end
    end
  end
end
