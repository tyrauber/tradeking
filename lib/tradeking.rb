require 'rubygems'
%w(article client collection market option quote request timesale toplist utilities version watchlist watchlist_item).each do |file|
  require File.join(File.dirname(__FILE__), 'tradeking', file)
end