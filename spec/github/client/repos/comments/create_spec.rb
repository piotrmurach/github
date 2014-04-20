# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Comments, '#create' do
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

    it { expect { subject.create user }.to raise_error(ArgumentError) }

    it { expect { subject.create }.to raise_error(ArgumentError) }

    it "should fail to create resource if 'body' input is missing" do
      expect {
        subject.create user, repo, sha, inputs.except('body')
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should create resource successfully" do
      subject.create user, repo, sha, inputs
      a_post(request_path).with(inputs).should have_been_made
    end

    it "should return the resource" do
      comment = subject.create user, repo, sha, inputs
      comment.should be_a Github::ResponseWrapper
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
