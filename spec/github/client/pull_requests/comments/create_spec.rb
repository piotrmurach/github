# encoding: utf-8

require 'spec_helper'

describe Github::Client::PullRequests::Comments, '#create' do
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/pulls/#{number}/comments" }
  let(:number) { 1 }
  let(:inputs) {
    {
      "body" => "Nice change",
      "commit_id" => "6dcb09b5b57875f334f61aebed695e2e4193db5e",
      "path" => "file1.txt",
      "position" => 4,
      "in_reply_to" => 4,
      'unrelated' => 'giberrish'
    }
  }

  before {
    stub_post(request_path).with(inputs.except('unrelated')).
      to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce created" do
    let(:body) { fixture('pull_requests/comment.json') }
    let(:status) { 201 }

    it { expect { subject.create }.to raise_error(ArgumentError) }

    it 'raises error when number is missing' do
      expect { subject.create user, repo }.to raise_error(ArgumentError)
    end

    it "should create resource successfully" do
      subject.create user, repo, number, inputs
      a_post(request_path).with(inputs).should have_been_made
    end

    it "should return the resource" do
      pull_request = subject.create user, repo, number, inputs
      pull_request.should be_a Github::ResponseWrapper
    end

    it "should get the request information" do
      pull_request = subject.create user, repo, number, inputs
      pull_request.id.should == number
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create user, repo, number, inputs }
  end
end # create
