require 'pathname'
require 'date'

Commit = Struct.new(:lines) do
  AUTHOR_RE = /Author:\s+(?<first_name>\w+)\s+(?<last_name>\w+)\s+<(?<email_address>.+)>/
  DATE_RE = /Date:\s+(?<commit_date>.+)/
  def commit_hash
    lines[0].strip
  end

  def commit_author
    lines.find{|line| line =~ /Author/}.strip.match(AUTHOR_RE)
  end

  def first_name
    commit_author[:first_name]
  end

  def last_name
    commit_author[:last_name]
  end

  def email_address
    commit_author[:email_address]
  end

  def commit_date
    dt_str = lines.find{|line| line =~ /Date/}.strip.match(DATE_RE)[:commit_date]
    Date.parse(dt_str)
  end

  def commit_message
    date_str = lines.find{|line| line =~ /Date/}
    idx = lines.index(date_str)
    lines[(idx + 1)..].map(&:strip).join
  end

  def to_hash
    {
      author: {
        first_name: first_name,
        last_name: last_name,
        email_address: email_address
      },
      commit_message: commit_message,
      commit_date: commit_date.strftime("%Y-%m-%dT%l:%M:%S%z"),
      commit_hash: commit_hash
    }
  end
end

class GitLog
  attr_reader :log_file, :path

  def initialize(log_file: )
    @path = Pathname.new(log_file).realdirpath.to_s
    @log_file = File.read(@path).strip
  end

  def commits
    @commits = log_file.split('commit').map do |commit|
      next if commit.strip.empty?
      Commit.new(commit.strip.split(/\r/))
    end.compact
  end
end
