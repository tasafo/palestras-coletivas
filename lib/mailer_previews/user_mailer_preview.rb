class UserMailerPreview < ActionMailer::Preview
  def password_reset
    UserMailer.password_reset(User.first.id)
  end
end
