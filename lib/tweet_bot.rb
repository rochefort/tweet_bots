#!/usr/bin/env ruby
require_relative "../config/boot"
require "rss"
require "yaml"
require "twitter"

class TweetBot
  USER_RSS = "https://queryfeed.net/twitter?title-type=user-name-both&geocode=&q=%40"

  def initialize(user_name)
    config = YAML.load_file(File.join(PROJECT_ROOT, "config/settings.yml"))
    t = config[user_name]
    @client = Twitter::REST::Client.new do |c|
      c.consumer_key        = t["consumer_key"]
      c.consumer_secret     = t["consumer_secret"]
      c.access_token        = t["access_token"]
      c.access_token_secret = t["access_token_secret"]
    end
    @retweet_users = t["retweet_users"]
    @debug = !ENV["DEBUG"].nil?
  end

  def tweet(msg)
    @client.update(msg)
  rescue => e
    p e if @debug
  end

  def fav_and_retweet(id)
    result = @client.favorite(id)
    @client.retweet(id) unless result.empty?
  end

  def favs_and_retweets
    @retweet_users.each do |user|
      rss_url = "#{USER_RSS}#{user}"
      rss = RSS::Parser.parse(rss_url)
      rss.items.each do |item|
        guid = item.guid.content.match(/\d+$/).to_a[0]
        next unless guid
        fav_and_retweet(guid)
        sleep 1
      end
    end
  end
end
