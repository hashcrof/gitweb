require_relative 'git_log'
require 'sqlite3'

def import_git_log
  db = SQLite3::Database.open('test.db');

  log = GitLog.new(log_file: 'git.log')
  log.commits.map(&:to_hash).each do |commit|
    author = commit.delete(:author)
    row = db.get_first_row "SELECT * FROM authors WHERE first_name = ? AND last_name = ? AND  email_address = ?", *author.values_at(:first_name, :last_name, :email_address)
    author_id = (row && row.last) || db.execute("INSERT INTO authors(first_name, last_name, email_address) VALUES(?, ?, ?)", author.values_at(:first_name, :last_name, :email_address))
    commit[:author_id] = author_id
    cmt = db.execute("INSERT INTO git_commits(commit_message, commit_hash, commit_date, author_id) VALUES(?, ?, ?, ?)", commit.values_at(:commit_message, :commit_hash, :commit_date, :author_id))
  end
end
