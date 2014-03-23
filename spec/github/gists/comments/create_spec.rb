# encoding: utf-8

require 'spec_helper'

describe Github::Client::Gists::Comments, '#create' do
  let(:gist_id) { 1 }
  let(:request_path) { "/gists/#{gist_id}/comments" }
  let(:inputs) {
    { "body" =>"Just commenting for the sake of commenting",
      "unrelated" => true }
  }

  before {
    stub_post(request_path).with(inputs.except('unrelated')).
      to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce created" do
    let(:body) { fixture('gists/comment.json') }
    let(:status) { 201 }

    it "should fail to create resource if 'content' input is missing" do
      expect {
        subject.create gist_id, inputs.except('body')
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should create resource successfully" do
      subject.create gist_id, inputs
      a_post(request_path).with(inputs).should have_been_made
    end

    it "should return the resource" do
      comment = subject.create gist_id, inputs
      comment.should be_a Github::ResponseWrapper
    end

    it "should get the comment information" do
      comment = subject.create gist_id, inputs
      comment.user.login.should == 'octocat'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create gist_id, inputs }
  end

end # create
