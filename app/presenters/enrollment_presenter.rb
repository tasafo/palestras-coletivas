class EnrollmentPresenter
  attr_reader :user_id, :user_name, :type_message, :button_message,
              :option_value, :can_record_presence

  def initialize(args = {})
    args_size = args.size
    @user_id = args[:user].id if args_size == 1

    return unless args_size > 1

    prepare_message args[:enrollment], args[:option_type],
                    args[:authorized_edit], args[:user]
  end

  private

  def prepare_message(enrollment, option_type, authorized_edit, user)
    @can_record_presence = (authorized_edit || user == enrollment.user)

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
    return unless @can_record_presence

    user = enrollment.user
    @user_id = user.id
    @user_name = user.name

    if enrollment.present?
      @button_message = I18n.t('show.event.undo_presence')
    else
      @type_message = 'text-success'
      @option_value = true
      @button_message = I18n.t('show.event.record_presence')
    end
  end
end
