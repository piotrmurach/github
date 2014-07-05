# encoding: utf-8

require 'spec_helper'

describe Github::Client::Issues::Comments, '#edit' do
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:number) { 1 }
  let(:inputs) { { 'body' => 'a new comment' } }
  let(:request_path) { "/repos/#{user}/#{repo}/issues/comments/#{number}" }

  before {
    stub_patch(request_path).with(:body => inputs).
      to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce edited" do
    let(:body) { fixture('issues/comment.json') }
    let(:status) { 201 }

    it "should fail to create resource if 'body' input is missing" do
      expect {
        subject.edit user, repo, number, inputs.except('body')
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should create resource successfully" do
      subject.edit user, repo, number, inputs
      a_patch(request_path).with(inputs).should have_been_made
    end

    it "should return the resource" do
      comment = subject.edit user, repo, number, inputs
      comment.should be_a Github::ResponseWrapper
    end

    it "should get the comment information" do
      comment = subject.edit user, repo, number, inputs
      comment.user.login.should == 'octocat'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.edit user, repo, number, inputs }
  end
end # edit
