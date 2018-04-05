require "redis"
conf = YAML.load_file("#{Rails.root}/config/redis.yml")[Rails.env]
$redis = Redis.new(conf.symbolize_keys)