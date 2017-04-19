#!/usr/bin/env ruby
require_relative "../config/boot"
require "twitter"

class TweetBot
  def initialize(user_name)
    config = YAML.load_file(File.join(PROJECT_ROOT, "config/settings.yml"))
    t = config[user_name]
    @client = Twitter::REST::Client.new do |c|
      c.consumer_key        = t["consumer_key"]
      c.consumer_secret     = t["consumer_secret"]
      c.access_token        = t["access_token"]
      c.access_token_secret = t["access_token_secret"]
    end
    @debug = !ENV["DEBUG"].nil?
  end

  def tweet(msg)
    @client.update(msg)
  rescue => e
    p e if @debug
  end
end
