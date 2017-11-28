rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'

template = ERB.new(File.new(rails_root + '/config/config.yml').read)
APP_CONFIG = YAML.load(template.result(binding))[Rails.env]
