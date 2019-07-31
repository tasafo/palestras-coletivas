require 'csv'

#:nodoc:
class ExportSubscriber
  def self.profiles
    [
      [I18n.t('titles.export_subscribers.profiles.speakers'), 'speakers'],
      [I18n.t('titles.export_subscribers.profiles.organizers'), 'organizers'],
      [
        I18n.t('titles.export_subscribers.profiles.participants'),
        'participants'
      ]
    ]
  end

  def self.as_csv(event, profile)
    users = case profile
            when 'speakers' then speakers(event)
            when 'organizers' then organizers(event)
            when 'participants' then participants(event)
            end

    CSV.generate do |csv|
      users.each do |user|
        csv << user
      end
    end
  end

  def self.speakers(event)
    users = []

    event.schedules.with_relations.each do |schedule|
      next unless schedule.talk?

      talk = schedule.talk

      talk.users.each do |user|
        users << [user.email, user.name, talk.title]
      end
    end

    users
  end

  def self.organizers(event)
    event.users.map { |user| [user.email, user.name] }
  end

  def self.participants(event)
    event.enrollments.with_user.map do |enrollment|
      [enrollment.user.email, enrollment.user.name]
    end
  end
end
