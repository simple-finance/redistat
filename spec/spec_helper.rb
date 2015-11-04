# add project-relative load paths
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'simplecov'
SimpleCov.start do
  add_filter '/spec'
  add_filter '/vendor'
end

# require stuff
require 'redistat'
require 'rspec'
require 'rspec/autorun'

REDIS_HOST = ENV.fetch('REDIS_HOST', 'localhost')
REDIS_PORT = ENV.fetch('REDIS_PORT', 8379).to_i
REDIS_DB   = ENV.fetch('REDIS_DB', 15).to_i

# use the test Redistat instance
Redistat.connect host: REDIS_HOST, port: REDIS_PORT, db: REDIS_DB, thread_safe: true
Redistat.redis.flushdb
