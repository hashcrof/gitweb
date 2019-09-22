require "sqlite3"
DB_NAME = "test.db"

def create_db
  # Open a database
  db = SQLite3::Database.new DB_NAME
  db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS authors (
      first_name varchar(30),
      last_name varchar(30),
      email_address varchar(255),
      id INTEGER PRIMARY KEY AUTOINCREMENT
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
end

def drop_db
  system "rm test.db"
end

send(ARGV[0])
