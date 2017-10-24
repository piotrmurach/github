# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::PullRequests, '#update' do
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:number) { 1347 }
  let(:request_path) { "/repos/#{user}/#{repo}/pulls/#{number}" }
  let(:inputs) {
    {
      "title" => "new title",
      "body" => "updated body",
      "state" => "open"
    }
  }

  before {
    stub_patch(request_path).with(body: inputs).
      to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce updateed" do
    let(:body)   { fixture('pull_requests/pull_request.json') }
    let(:status) { 201 }

    it { expect { subject.update }.to raise_error(ArgumentError) }

    it { expect { subject.update user }.to raise_error(ArgumentError) }

    it "should create resource successfully" do
      subject.update user, repo, number, inputs
      expect(a_patch(request_path).with(body: inputs)).to have_been_made
    end

    it "should return the resource" do
      pull_request = subject.update user, repo, number, inputs
      expect(pull_request).to be_a Github::ResponseWrapper
    end

    it "should get the pull_request information" do
      pull_request = subject.update user, repo, number, inputs
      expect(pull_request.title).to eq('new-feature')
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.update user, repo, number, inputs }
  end

end # update
