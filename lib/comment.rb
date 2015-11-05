class Comment

  attr_reader :post_item_id, :text

  def initialize(text)
    @post_item_id = 0
    @text = text
  end

end
