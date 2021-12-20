#:nodoc:
class UserMailer < ApplicationMailer
  def password_reset(user_id)
    @user = User.find(user_id)

    mail to: @user.email, subject: t('titles.users.reset_password')
  end
end
