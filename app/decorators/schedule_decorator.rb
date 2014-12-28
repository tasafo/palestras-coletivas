class ScheduleDecorator
  def initialize(schedule, old_talk_id, talk_id, params = nil)
    @schedule = schedule
    @old_talk_id = old_talk_id
    @talk_id = talk_id
    @params = params
  end

  def create
    @schedule.save && update_counter_of_users_talks
  end

  def update
    @schedule.update_attributes(@params) && update_counter_of_users_talks
  end

private

  def update_counter_of_users_talks
    unless @old_talk_id.blank?
      if @old_talk_id != @talk_id
        old_talk = Talk.find(@old_talk_id)

        old_talk.users.each do |user|
          user.set_counter(:presentation_events, :dec)
        end

        old_talk.set_counter(:presentation_events, :dec)
      end
    end

    if @schedule.talk?
      @schedule.talk.users.each do |user|
        user.set_counter(:presentation_events, :inc)
      end

      @schedule.talk.set_counter(:presentation_events, :inc)
    end

    true
  end
end