class Schedule
  include Mongoid::Document
  include Mongoid::Timestamps

  field :day, type: Integer
  field :time, type: String
  field :environment, type: String

  belongs_to :event

  belongs_to :activity

  belongs_to :talk

  validates_presence_of :day, :time, :event, :activity

  scope :by_day, lambda { |day| where(:day => day).order_by(:time => :asc) }

  def update_counter_of_users_talks(old_talk_id, talk_id)
    unless old_talk_id.blank?
      if old_talk_id != talk_id
        old_talk = Talk.find(old_talk_id)

        old_talk.users.each do |user|
          user.set_counter(:presentation_events, :dec)
        end

        old_talk.set_counter(:presentation_events, :dec)
      end
    end

    if talk?
      talk.users.each do |user|
        user.set_counter(:presentation_events, :inc)
      end

      talk.set_counter(:presentation_events, :inc)
    end    
  end
end