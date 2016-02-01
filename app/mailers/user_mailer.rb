#:nodoc:
class UserMailer < ActionMailer::Base
  default from: 'Palestras Coletivas <no-reply@palestrascoletivas.com.br>'

  def password_reset(user_id)
    @user = User.find(user_id)

    mail to: @user.email, subject: t('titles.users.reset_password')
  end
end
