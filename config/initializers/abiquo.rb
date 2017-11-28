rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'

template = ERB.new(File.new(rails_root + '/config/abiquo.yml').read)
ABQ_CONFIG = YAML.load(template.result(binding))[rails_env].symbolize_keys
