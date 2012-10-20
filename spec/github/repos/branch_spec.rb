# encoding: utf-8

require 'spec_helper'

describe Github::Repos, '#branch' do
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
      repo_branch.should be_a Hashie::Mash
    end

    it "should get repository branch information" do
      repo_branch = subject.branch user, repo, branch
      repo_branch.name.should == 'master'
    end
  end

  context "resource not found" do
    let(:body)   { '' }
    let(:status) { 404 }

    it "should fail to get resource" do
      expect {
        subject.branch user, repo, branch
      }.to raise_error(Github::Error::NotFound)
    end
  end
end # branch
