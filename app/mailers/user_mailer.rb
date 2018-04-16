#:nodoc:
class UserMailer < ActionMailer::Base
  default from: "#{I18n.t('app.name')} <no-reply@#{ENV['DEFAULT_URL']}>"

  def password_reset(user_id)
    @user = User.find(user_id)

    mail to: @user.email, subject: t('titles.users.reset_password')
  end
end
