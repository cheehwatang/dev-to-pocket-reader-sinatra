require 'pry-byebug'

class Author
  def initialize(attributes = {})
    @id = attributes[:id] || 0
    @nickname = attributes[:nickname] || ''
    @name = attributes[:name] || ''
    @description = attributes[:description] || ''
    @posts_published = attributes[:posts_published] || -1
    @comments_written = attributes[:comments_written] || -1
  end

  def self.all
    query = <<-SQL
      SELECT * FROM authors
    SQL
    DB.results_as_hash = true
    DB.execute(query)
  end

  def self.find(id)
    query = <<-SQL
      SELECT * FROM authors
      WHERE authors.id = ?
    SQL
    DB.results_as_hash = true
    DB.execute(query, id).first
  end

  def save
    author_in_db? ? update : create
  end

  private

  def update
    query = <<-SQL
      UPDATE authors
      SET nickname = ?, name = ?, description = ?, posts_published = ?, comments_written = ?
      WHERE id = ?
    SQL
    DB.execute(query, @nickname, @name, @description, @posts_published, @comments_written, @id)
  end

  def create
    query = <<-SQL
      INSERT INTO authors (nickname, name, description, posts_published, comments_written)
      VALUES(?, ?, ?, ?, ?)
    SQL
    DB.execute(query, @nickname, @name, @description, @posts_published, @comments_written)
  end

  def author_in_db?
    !self.class.find(@id).nil?
  end
end
