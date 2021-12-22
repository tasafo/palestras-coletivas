class ApplicationMailer < ActionMailer::Base
  default from: "#{I18n.t('app.name')} <no-reply@#{ENV['DEFAULT_URL']}>"
  layout 'mailer'
end
