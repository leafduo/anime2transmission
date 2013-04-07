# encoding: utf-8

require 'feedzirra'

filter_filename = File.join([File.dirname(__FILE__), 'filters.txt'])
filters = []
File.open(filter_filename, "r:UTF-8").each do |filter_string|
    filter_string.strip!
    filter_string.gsub!(/ /, '.*')
    filter_string.gsub!(/\[/, '\[')
    filter_string.gsub!(/\]/, '\]')
    filter = Regexp.new filter_string
    filters.push(filter)
end

p filters
puts

links_to_add = []
Feedzirra::Feed.add_common_feed_entry_element(:enclosure, :value => :url, :as => :enclosure_url) 
feed = Feedzirra::Feed.fetch_and_parse('http://share.dmhy.org/topics/rss/rss.xml')
feed.entries.each do |entry|
    if filters.any? { |filter| entry.title =~ filter }
        puts entry.title
        links_to_add.push entry.enclosure_url
    end
end

links_to_add.map! { |link| "\"#{link}\""}
links_to_add = links_to_add.join(' ')
exec "xunlei-lixian/lixian_cli.py add --bt #{links_to_add}"