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
    return nil if attributes.nil?

    attributes['author'] = Author.find(attributes['author_id'])
    new(attributes.transform_keys(&:to_sym))
  end

  def save
    post_in_db? ? update : insert
  end

  def destroy
    query = <<-SQL
      DELETE FROM posts
      WHERE posts.id = ?
    SQL
    DB.execute(query, @id)
  end

  def read?
    @read
  end

  private

  def update
    query = <<-SQL
      UPDATE posts
      SET title = ?, content = ?, path = ?, read = ?, author_id = ?
      WHERE posts.id = ?
    SQL
    DB.execute(query, @title, @content, @path, (read? ? 1 : 0), @author.id, @id)
  end

  def insert
    query = <<-SQL
      INSERT INTO posts (title, content, path, read, author_id)
      VALUES(?, ?, ?, ?, ?)
    SQL
    DB.execute(query, @title, @content, @path, (read? ? 1 : 0), @author.id)
    @id = DB.last_insert_row_id
  end

  def post_in_db?
    !self.class.find(@id).nil?
  end
end
