require 'csv'

#:nodoc:
class ExportSubscriber
  def self.profiles
    [
      [ I18n.t('titles.export_subscribers.profiles.speakers'), 'speakers' ],
      [ I18n.t('titles.export_subscribers.profiles.organizers'), 'organizers' ],
      [ I18n.t('titles.export_subscribers.profiles.participants'), 'participants' ]
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

  private

  def self.speakers(event)
    users = []

    event.schedules.with_includes.each do |schedule|
      next unless schedule.talk?

      talk = schedule.talk

      talk.users.each do |user|
        users << [ user.email, user.name, talk.title ]
      end
    end

    users
  end

  def self.organizers(event)
    users = []

    event.users.each do |user|
      users << [ user.email, user.name ]
    end

    users
  end

  def self.participants(event)
    users = []

    event.enrollments.with_user.each do |enrollment|
      users << [ enrollment.user.email, enrollment.user.name ]
    end

    users
  end
end