# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Commits, '#compare' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:base) { 'master' }
  let(:head) { 'topic' }
  let(:request_path) { "/repos/#{user}/#{repo}/compare/#{base}...#{head}" }

  before {
    stub_get(request_path).
      to_return(:body => fixture('repos/commit_comparison.json'),
        :status => 200,
        :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  it { expect { subject.compare }.to raise_error(ArgumentError) }

  it "should fail to get resource without base" do
    expect { subject.compare user, repo, nil, head }.to raise_error(ArgumentError)
  end

  it "should compare successfully" do
    subject.compare user, repo, base, head
    a_get(request_path).should have_been_made
  end

  it "should get comparison information" do
    commit = subject.compare user, repo, base, head
    commit.base_commit.commit.author.name.should == 'Monalisa Octocat'
  end
end # compare
