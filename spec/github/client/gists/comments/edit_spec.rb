# encoding: utf-8

require 'spec_helper'

describe Github::Client::Gists::Comments, '#create' do
  let(:gist_id) { 1 }
  let(:comment_id) { 1 }
  let(:request_path) { "/gists/#{gist_id}/comments/#{comment_id}" }
  let(:inputs) {
    { "body" =>"Just commenting for the sake of commenting",
      "unrelated" => true }
  }

  before {
    stub_patch(request_path).with(inputs.except('unrelated')).
      to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce edited" do
    let(:status) { 201 }
    let(:body) { fixture('gists/comment.json') }

    it "should fail to create resource if 'content' input is missing" do
      expect {
        subject.edit gist_id, comment_id, inputs.except('body')
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should create resource successfully" do
      subject.edit gist_id, comment_id, inputs
      a_patch(request_path).with(inputs).should have_been_made
    end

    it "should return the resource" do
      comment = subject.edit gist_id, comment_id, inputs
      comment.should be_a Github::ResponseWrapper
    end

    it "should get the comment information" do
      comment = subject.edit gist_id, comment_id, inputs
      comment.user.login.should == 'octocat'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.edit gist_id, comment_id, inputs }
  end

end # edit
