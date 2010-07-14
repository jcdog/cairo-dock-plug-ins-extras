# This is a part of the external WebSearch applet for Cairo-Dock
# Author: Eduardo Mucelli Rezende Oliveira
# E-mail: edumucelli@gmail.com or eduardom@dcc.ufmg.br
#
# This module fetch results from Twitter, including thumbnails - www.twitter.com

class Twitter < Engine

	def initialize
		self.name = self.class.to_s
		self.query_url = "http://search.twitter.com/search?q="											# 15 results per page
		super
	end

	# url, e.g., http://twitter.com/runscored_cin/statuses/14382443834
	# thumb_url, e.g., http://a1.twimg.com/profile_images/768793556/n12430139_39051956_3639_normal.jpg ; twitter does not change the original pic name
	# description, e.g, Dusty, I hope you literally kill Miguel Cairo with your words after today. #RedsFAIL
	def retrieve_links(query, page = 1)
		twitter = Nokogiri::HTML.parse(open(URI.encode("#{self.query_url}#{query}&page=#{page}")))
		(twitter/"div[@id='results']/ul").each do |res|
			(res/"li").each do |raw_result|
				thumb_url = raw_result.at("div[@class='avatar']/a/img")['src']							# the thumb of the avatar which tweeted
				description = raw_result.at("div[@class='msg']/span[@class^='msgtxt']").inner_text		# the tweet text
				url = raw_result.at("div[@class='info']/a[@class='lit']")['href']						# url of the tweet
				self.links << ThumbnailedLink.new(url, description, thumb_url, self.name)
			end
		end
		self.links
	end

end
