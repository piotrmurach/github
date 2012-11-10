# encoding: utf-8

require 'spec_helper'

describe Github::Repos::Comments, '#create' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:sha) { '23432dfosfsufd' }
  let(:inputs) do
    { 'body' => 'web',
      :commit_id => 1,
      :line => 1,
      :path => 'file1.txt',
      :position => 4 }
  end
  let(:request_path) { "/repos/#{user}/#{repo}/commits/#{sha}/comments" }

  before {
    stub_post(request_path).with(inputs).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  context "resouce created" do
    let(:body)   { fixture('repos/commit_comment.json') }
    let(:status) { 201 }

    it "should fail to create resource if 'body' input is missing" do
      expect {
        subject.create user, repo, sha, inputs.except('body')
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should fail to create resource if 'commit_id' input is missing" do
      expect {
        subject.create user, repo, sha, inputs.except(:commit_id)
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should fail to create resource if 'line' input is missing" do
      expect {
        subject.create user, repo, sha, inputs.except(:line)
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should fail to create resource if 'path' input is missing" do
      expect {
        subject.create user, repo, sha, inputs.except(:path)
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should fail to create resource if 'position' input is missing" do
      expect {
        subject.create user, repo, sha, inputs.except(:position)
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should create resource successfully" do
      subject.create user, repo, sha, inputs
      a_post(request_path).with(inputs).should have_been_made
    end

    it "should return the resource" do
      comment = subject.create user, repo, sha, inputs
      comment.should be_a Hashie::Mash
    end

    it "should get the commit comment information" do
      comment = subject.create user, repo, sha, inputs
      comment.user.login.should == 'octocat'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create user, repo, sha, inputs }
  end
end # create
