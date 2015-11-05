

class Post

  attr_reader   :comment_list
  attr_accessor :title, :url, :points, :item_id, :days_ago_posted

  def initialize
    @title = ''      # title on Hacker News
    @url = 'http://wwww.google.com'    # the post's URL
    @points = 0      # the number of points the post currently has
    @item_id = 0     # the post's Hacker News item ID
    @comment_list = []
    @days_ago_posted = 0
  end

  #comments returns all the comments associated with a particular post
  def comments

    @comment_list

  end

  #add_comment takes a Comment object as its input and adds it to the comment list.
  def add_comment(comment)
    @comment_list << comment
  end

end
