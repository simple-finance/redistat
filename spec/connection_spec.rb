require "spec_helper"
include Redistat

describe Redistat::Connection do

  before(:each) do
    @redis = Redistat.redis
  end

  it "should have a valid Redis client instance" do
    Redistat.redis.should_not be_nil
  end

  it "should have initialized custom testing connection" do
    @redis.client.host.should == REDIS_HOST
    @redis.client.port.should == REDIS_PORT
    @redis.client.db.should == REDIS_DB
  end

  it "should be able to set and get data" do
    @redis.set("hello", "world")
    @redis.get("hello").should == "world"
    @redis.del("hello").should be_true
  end

  it "should be able to store hashes to Redis" do
    @redis.hset("hash", "field", "1")
    @redis.hget("hash", "field").should == "1"
    @redis.hincrby("hash", "field", 1)
    @redis.hget("hash", "field").should == "2"
    @redis.hincrby("hash", "field", -1)
    @redis.hget("hash", "field").should == "1"
    @redis.del("hash")
  end

  it "should be accessible from Redistat module" do
    Redistat.redis.should == Connection.get
    Redistat.redis.should == Redistat.connection
  end

  it "should handle multiple connections with refs" do
    Redistat.redis.client.db.should == REDIS_DB
    Redistat.connect(:port => REDIS_PORT, :db => 7, :ref => "Custom")
    Redistat.redis.client.db.should == REDIS_DB
    Redistat.redis("Custom").client.db.should == 7
  end

  it "should be able to overwrite default and custom refs" do
    Redistat.redis.client.db.should == REDIS_DB
    Redistat.connect(:port => REDIS_PORT, :db => REDIS_DB)
    Redistat.redis.client.db.should == REDIS_DB

    Redistat.redis("Custom").client.db.should == 7
    Redistat.connect(:port => REDIS_PORT, :db => 8, :ref => "Custom")
    Redistat.redis("Custom").client.db.should == 8

    # Reset the default connection to the testing server or all hell
    # might brake loose from the rest of the specs
    Redistat.connect(:port => REDIS_PORT, :db => REDIS_DB)
  end

  # TODO: Test thread-safety
  it "should be thread-safe" do
    pending("need to figure out a way to test thread-safety")
  end

end
