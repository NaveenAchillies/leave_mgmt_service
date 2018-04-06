require "redis"
require 'uri'
# conf = YAML.load_file("#{Rails.root}/config/redis.yml")[Rails.env]
uri = URI.parse(ENV["REDISTOGO_URL"]||"redis://localhost:6379/")
$redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
# Resque.redis = REDIS