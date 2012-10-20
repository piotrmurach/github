# encoding: utf-8

require 'spec_helper'

describe Github::Repos, '#get' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}" }

  before {
    stub_get(request_path).
      to_return(:body => body, :status => status, :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  context "resource found" do
    let(:body)   { fixture('repos/repo.json') }
    let(:status) { 200 }

    it { should respond_to(:find) }

    it "should raise error when no user/repo parameters" do
      expect {
        subject.get nil, repo
      }.to raise_error(ArgumentError, /\[user\] parameter cannot be nil/)
    end

    it "should raise error when no repository" do
      # github.user, github.repo = nil, nil
      expect {
        subject.get user, nil
      }.to raise_error(ArgumentError, /\[repo\] parameter cannot be nil/)
    end

    it "should find resources" do
      subject.get user, repo
      a_get(request_path).should have_been_made
    end

    it "should return repository mash" do
      repository = subject.get user, repo
      repository.should be_a Hashie::Mash
    end

    it "should get repository information" do
      repository = subject.get user, repo
      repository.name.should == 'Hello-World'
    end
  end

  context "resource not found" do
    let(:body)   { '' }
    let(:status) { 404 }

    it "should fail to get resource" do
      expect {
        subject.get user, repo
      }.to raise_error(Github::Error::NotFound)
    end
  end
end # get
