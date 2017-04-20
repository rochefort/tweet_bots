#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "../../lib"))

require "tweet_bot"
TweetBot.new("serie_a_bot").favs_and_retweets
