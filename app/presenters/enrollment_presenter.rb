#:nodoc:
class EnrollmentPresenter
  attr_reader :user_id, :user_name, :type_message, :button_message,
              :option_value, :can_record_presence

  def initialize(args = {})
    @user_id = args[:user].id if args.size == 1

    prepare_message args[:event], args[:enrollment], args[:option_type],
                    args[:authorized_edit], args[:user] if args.size > 1
  end

  private

  def prepare_message(event, enrollment, option_type, authorized_edit, user)
    @can_record_presence = (authorized_edit || user == enrollment.user) &&
                           Time.zone.today >= event.start_date

    @option_value = false
    @type_message = 'text-warning'

    case option_type
    when 'active'
      option_active enrollment, user
    when 'present'
      option_present enrollment
    end
  end

  def option_active(enrollment, user)
    @user_id = user.id
    @user_name = user.name

    if enrollment.active?
      @button_message = I18n.t('show.event.cancel_my_participation')
    else
      @type_message = 'text-success'
      @option_value = true
      @button_message = I18n.t('show.event.participate')
    end
  end

  def option_present(enrollment)
    if @can_record_presence
      @user_id = enrollment.user.id
      @user_name = enrollment.user.name

      if enrollment.present?
        @button_message = I18n.t('show.event.undo_presence')
      else
        @type_message = 'text-success'
        @option_value = true
        @button_message = I18n.t('show.event.record_presence')
      end
    end
  end
end
