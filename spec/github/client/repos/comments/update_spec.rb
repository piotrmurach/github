# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Comments, '#update' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:comment_id) { 1 }
  let(:inputs) { {'body'=> 'web'} }
  let(:request_path) { "/repos/#{user}/#{repo}/comments/#{comment_id}" }

  before {
    stub_patch(request_path).with(inputs).
      to_return(:body => body,:status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
  }

  context "resouce created" do
    let(:body)   { fixture('repos/commit_comment.json') }
    let(:status) { 200 }

    it "should fail to create resource if 'body' input is missing" do
      expect {
        subject.update user, repo, comment_id, inputs.except('body')
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should create resource successfully" do
      subject.update user, repo, comment_id, inputs
      a_patch(request_path).with(inputs).should have_been_made
    end

    it "should return the resource" do
      comment = subject.update user, repo, comment_id, inputs
      comment.should be_a Github::ResponseWrapper
    end

    it "should get the commit comment information" do
      comment = subject.update user, repo, comment_id, inputs
      comment.user.login.should == 'octocat'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.update user, repo, comment_id, inputs }
  end
end # update
