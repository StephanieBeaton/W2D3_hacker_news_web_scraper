
# Nokogiri documentation about parsing a HTML document
# http://www.nokogiri.org/tutorials/parsing_an_html_xml_document.html

require 'nokogiri'
require 'open-uri'
require 'colorize'
require './lib/post.rb'
require './lib/comment.rb'


#  Example command line

# $ ruby hn_scraper.rb https://news.ycombinator.com/item?id=7663775
# Post title: XXXXXX
# Number of comments: XXXXX
# ... some other statistics we might be interested in -- your choice ...

# quit unless our script gets two command line arguments
unless ARGV.length == 1
  puts "Dude, not the right number of arguments."
  puts "Usage: ruby hn_scraper.rb https://news.ycombinator.com/item?id=7663775\n"
  exit
end

puts "hacker_news_url = #{ARGV[0]}"

filename = ARGV[0]
#filename = 'post.html'


#  read html file from local harddrive to avoid hitting Hacker News website
#   ... many times

doc = Nokogiri::HTML(File.open(filename))

#  Nokogiri::HTML( )  is a constructor

# The Nokogiri::HTML construct takes in the opened file's contents
# and wraps it in a special Nokogiri data object.


# What open-uri (open) does for us is encapsulate all the work of making a HTTP request
# into the open method,
# making the operation as simple as as opening a file on our own hard drive.



#  ... eventually have to uncomment this...

# hacker_news_url = ARGV[0]
# hacker_news_url = "https://news.ycombinator.com/item?id=7663775"
# html_file = open(hacker_news_url)
# puts html_file.read
# doc = Nokogiri::HTML(html_file)

# Parsing HTML with Nokogiri  from "The Bastard's Book of Ruby"
#  http://ruby.bastardsbook.com/chapters/html-parsing/

# puts doc.class   # => Nokogiri::HTML::Document








# 1. Instantiates a Post object

  post = Post.new

# 2. Parses the Hacker News HTML

    # get comments using "search" ?

    #  get Post attributes -  title, url, points, item_id
    #  ... call writer method to add them to post

    count_title = 1
    doc.search('td.title a').map do |link|

      if count_title == 1
        # puts "count_title = #{count_title}"
        count_title += 1

        post.title = link.inner_text
        post.title = post.title.slice("Show HN: ".length, (post.title.length - "Show HN: ".length))
        # puts "title = #{post.title}"
        post.url = link['href']
        # puts "url = #{post.url}"
      end
    end

    doc.search('span.score').map do |span|
      post.points = span.inner_html
      post.points = post.points.slice(0, (post.points.length - " points".length))
      # puts "points = #{post.points}"

      post.item_id = span['id']
      post.item_id = post.item_id.slice("score_".length, (post.item_id.length - "score_".length) )
      # puts "item_id = #{post.item_id}"

    end

    doc.search('td.subtext a:nth-child(3)').map do |span|
      post.days_ago_posted = span.inner_text
      # example   554 days ago
      post.days_ago_posted = post.days_ago_posted.slice(0, (post.days_ago_posted.length - " days ago".length))
    end


# 3. Creates a new Comment object for each comment in the HTML  ( comment = Comment.new ) ,
#    ...adding it to the Post object in (1)  (post.add_comment() )


    nbr_of_comments = 0
    doc.search('span.comment > span').map do |span|
      # puts span.inner_text
      nbr_of_comments += 1
      comment = Comment.new(span.inner_text)
      post.add_comment(comment)
    end

    # puts "nbr_of_comments = #{nbr_of_comments}"


post.comments.each do |comment|
  puts comment.text.green
end

# Post title: XXXXXX
# Number of comments: XXXXX
# ... some other statistics we might be interested in -- your choice ...
puts ""
puts ""
puts "Post title: #{post.title}".red
puts "Number of comments: #{post.comment_list.length}".green
puts "Number of days ago posted : #{post.days_ago_posted}".blue






