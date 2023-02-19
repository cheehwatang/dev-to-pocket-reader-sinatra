require 'pry-byebug'

class Author
  attr_reader :id

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
    DB.execute(query).map { |attributes| new(attributes.transform_keys(&:to_sym)) }
  end

  def self.find(id)
    query = <<-SQL
      SELECT * FROM authors
      WHERE authors.id = ?
    SQL
    DB.results_as_hash = true
    attributes = DB.execute(query, id).first
    return nil if attributes.nil?

    new(attributes.transform_keys(&:to_sym))
  end

  def save
    author_in_db? ? update : insert
  end

  def destroy
    query = <<-SQL
      DELETE FROM authors
      WHERE authors.id = ?
    SQL
    DB.execute(query, @id)
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

  def insert
    query = <<-SQL
      INSERT INTO authors (nickname, name, description, posts_published, comments_written)
      VALUES(?, ?, ?, ?, ?)
    SQL
    DB.execute(query, @nickname, @name, @description, @posts_published, @comments_written)
    @id = DB.last_insert_row_id
  end

  def author_in_db?
    !self.class.find(@id).nil?
  end
end
