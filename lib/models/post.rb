require_relative './author'

class Post
  def initialize(attributes = {})
    @id = attributes[:id] || 0
    @title = attributes[:title] || ''
    @content = attributes[:content] || ''
    @path = attributes[:path] || ''
    @read = attributes[:read] || false
    @author = attributes[:author]
  end

  def self.all
    query = <<-SQL
      SELECT * FROM posts
    SQL
    DB.results_as_hash = true
    DB.execute(query).map do |attributes|
      attributes['author'] = Author.find(attributes['author_id'])
      new(attributes.transform_keys(&:to_sym))
    end
  end

  def self.find(id)
    query = <<-SQL
      SELECT * FROM posts
      WHERE posts.id = ?
    SQL
    DB.results_as_hash = true;
    attributes = DB.execute(query, id).first
    attributes['author'] = Author.find(attributes['author_id'])
    new(attributes.transform_keys(&:to_sym))
  end
end
