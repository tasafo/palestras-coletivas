class UserMailer < ActionMailer::Base
  default from: "no-reply@palestrascoletivas.com"

  def password_reset(user)
    @user = user

    mail :to => user.email, :subject => t("titles.reset_password.new")
  end
end
