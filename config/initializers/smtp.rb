unless Rails.application.config.action_mailer.nil?

    options = YAML.load_file(Rails.root.join('config', 'config.yml'))[Rails.env]['smtp_settings']

    Rails.application.config.action_mailer.raise_delivery_errors = true
    Rails.application.config.action_mailer.perform_deliveries = true
    Rails.application.config.action_mailer.delivery_method = :smtp
    Rails.application.config.action_mailer.smtp_settings = {}
    Rails.application.config.action_mailer.default_url_options = {
        host: options['email_link_host'],
        port: options['email_link_port'],
        protocol: options['email_link_protocol'],
        script_name: options['email_link_path']
    }

    options.each do |name, value|
        value = value.to_sym if value.to_s.starts_with? ':'
        Rails.application.config.action_mailer.smtp_settings[name.to_sym] = value
    end unless options.nil?
end