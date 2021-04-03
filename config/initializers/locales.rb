Rails.application.config.i18n.load_path += Dir['config/locales/**/*.yml']

Rails.application.config.i18n.available_locales = %w[pt-BR en]

Rails.application.config.i18n.default_locale = 'pt-BR'

Rails.application.config.encoding = 'utf-8'

I18n.enforce_available_locales = true

Date::DATE_FORMATS[:default] = '%d/%m/%Y'
