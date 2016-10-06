rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'

APP_CONFIG = YAML.load_file(rails_root + '/config/config.yml')[Rails.env]
