require_relative '../git_log'

RSpec.describe GitLog do
  let(:commit) { subject.commits[0] }
  let(:other_commit) { subject.commits[9] }

  subject { described_class.new(log_file: 'git.log') }

  it 'has a log_file' do
    expect(subject).to be
    expect(subject.path).to match "gitweb/git.log"
    expect(subject.log_file).to be
  end

  it 'has many commits' do
    expect(subject.commits.size).to eq 11
  end

  it 'has a commit hash' do
    expect(commit.commit_hash).to eq '0662da725f942fdf0892fae5a44944e538bb3fe4'
    expect(other_commit.commit_hash).to eq 'ae5a30e09082bd5b613c14235b0dd77109f21dcd'
  end

  it 'has an author' do
    expect(commit.first_name).to eq 'John'
    expect(commit.last_name).to eq 'Doe'
    expect(commit.email_address).to eq 'John.Doe@test.com'

    expect(other_commit.first_name).to eq 'Susan'
    expect(other_commit.last_name).to eq 'Jones'
    expect(other_commit.email_address).to eq 'susan.jones@test.com'
  end

  it 'has a commit date' do
    expect(commit.commit_date).to eq Date.parse('Tue Mar 20 17:16:23 2012 -0400')
    expect(other_commit.commit_date).to eq Date.parse('Wed Mar 14 16:10:10 2012 -0400')
  end

  it 'has a commit message' do
    expect(commit.commit_message).to eq 'rollup interval converter testing'
    expect(other_commit.commit_message).to eq 'PDUs grid no longer depends on cookies.CR #39874'
  end
end
