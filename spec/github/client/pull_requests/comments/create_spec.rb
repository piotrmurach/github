# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::PullRequests::Comments, '#create' do
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
      to_return(body: body, status: status,
                headers: {content_type: "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce created" do
    let(:body) { fixture('pull_requests/comment.json') }
    let(:status) { 201 }

    it { expect { subject.create }.to raise_error(ArgumentError) }

    it 'raises error when number is missing' do
      expect { subject.create user, repo }.to raise_error(ArgumentError)
    end

    it "creates resource successfully" do
      subject.create user, repo, number, inputs
      expect(a_post(request_path).with(inputs)).to have_been_made
    end

    it "returns the resource" do
      pull_request = subject.create user, repo, number, inputs
      expect(pull_request).to be_a(Github::ResponseWrapper)
    end

    it "gets the request information" do
      pull_request = subject.create user, repo, number, inputs
      expect(pull_request.id).to eq(number)
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create user, repo, number, inputs }
  end
end # create
