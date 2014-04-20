# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos, '#branch' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/branches/#{branch}" }
  let(:branch) { 'master' }

  after { reset_authentication_for subject }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  context "resource found" do
    let(:body)   { fixture('repos/branch.json') }
    let(:status) { 200 }

    it "should find resources" do
      subject.branch user, repo, branch
      a_get(request_path).should have_been_made
    end

    it "should return repository mash" do
      repo_branch = subject.branch user, repo, branch
      repo_branch.should be_a Github::ResponseWrapper
    end

    it "should get repository branch information" do
      repo_branch = subject.branch user, repo, branch
      repo_branch.name.should == 'master'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.branch user, repo, branch }
  end
end # branch
