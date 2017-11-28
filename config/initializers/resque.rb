rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'

template = ERB.new(File.new(rails_root + '/config/resque.yml').read)
Resque.redis = YAML.load(template.result(binding))[rails_env]
