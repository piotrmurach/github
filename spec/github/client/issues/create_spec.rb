# encoding: utf-8

require 'spec_helper'

describe Github::Client::Issues, '#create' do
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/issues" }
  let(:inputs) {
    {
        "title" =>  "Found a bug",
        "body" => "I'm having a problem with this.",
        "assignee" =>  "octocat",
        "milestone" => 1,
        "labels" => [
          "Label1",
          "Label2"
        ]
    }
  }

  before {
    stub_post(request_path).with(inputs).
      to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce created" do
    let(:body) { fixture('issues/issue.json') }
    let(:status) { 201 }

    it "should fail to create resource if 'title' input is missing" do
      expect {
        subject.create user, repo, inputs.except('title')
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should create resource successfully" do
      subject.create user, repo, inputs
      a_post(request_path).with(inputs).should have_been_made
    end

    it "should return the resource" do
      issue = subject.create user, repo, inputs
      issue.should be_a Github::ResponseWrapper
    end

    it "should get the issue information" do
      issue = subject.create(user, repo, inputs)
      issue.title.should == 'Found a bug'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create user, repo, inputs }
  end

end # create
