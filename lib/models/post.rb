class Post
  def initialize(attributes = {})
    @id = attributes[:id] || 0
    @title = attributes[:title] || ''
    @content = attributes[:content] || ''
    @path = attributes[:path] || ''
    @read = attributes[:read] || false
    @author = nil
  end
end