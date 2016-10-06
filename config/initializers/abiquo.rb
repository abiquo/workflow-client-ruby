rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'

$abiquo_config = YAML.load_file(rails_root + '/config/abiquo.yml')[rails_env].symbolize_keys
