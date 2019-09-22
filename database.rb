require "sqlite3"

class Database
  DB_NAME = "test.db"
  def self.instance
    @@instance = SQLite3::Database.open('test.db') || create
  end

  def self.create
    db = SQLite3::Database.new Database::DB_NAME
    db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS authors (
        first_name varchar(30),
        last_name varchar(30),
        email_address varchar(255),
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        UNIQUE(first_name,last_name,email_address)
      );
    SQL

    db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS git_commits (
        commit_message varchar(255),
        commit_date DATETIME,
        commit_hash varchar(255),
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        author_id INTEGER
      );
    SQL

    db
  end
end
