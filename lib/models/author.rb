class Author
  def initialize(attributes = {})
    @id = attributes[:id] || 0
    @nickname = attributes[:nickname] || ''
    @name = attributes[:name] || ''
    @description = attributes[:description] || ''
    @posts_published = attributes[:posts_published] || 0
    @comments_written = attributes[:comments_written] || 0
  end
end