# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::PullRequests, '#create' do
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/pulls" }
  let(:inputs) {
    {
      "title" => "Amazing new feature",
      "body" => "Please pull this in!",
      "head" => "octocat:new-feature",
      "base" => "master",
      "state" => "open"
    }
  }

  before {
    stub_post(request_path).with(body: inputs.except('unrelated')).
      to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce created" do
    let(:body) { fixture('pull_requests/pull_request.json') }
    let(:status) { 201 }

    it { expect { subject.create }.to raise_error(ArgumentError) }

    it { expect { subject.create user }.to raise_error(ArgumentError) }

    it "should create resource successfully" do
      subject.create user, repo, inputs
      expect(a_post(request_path).with(body: inputs)).to have_been_made
    end

    it "should return the resource" do
      pull_request = subject.create user, repo, inputs
      expect(pull_request).to be_a Github::ResponseWrapper
    end

    it "should get the request information" do
      pull_request = subject.create user, repo, inputs
      expect(pull_request.title).to eql "new-feature"
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create user, repo, inputs }
  end
end # create
