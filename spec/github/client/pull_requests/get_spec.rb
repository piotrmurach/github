# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::PullRequests, '#get' do
  let(:user)   { 'peter-murach' }
  let(:repo) { 'github' }
  let(:number) { 1 }
  let(:request_path) { "/repos/#{user}/#{repo}/pulls/#{number}" }

  before {
    stub_get(request_path).to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context 'resource found' do
    let(:body) { fixture('pull_requests/pull_request.json') }
    let(:status) { 200 }

    it { is_expected.to respond_to :find }

    it { expect { subject.get }.to raise_error(ArgumentError) }

    it { expect { subject.get user }.to raise_error(ArgumentError) }

    it "should get the resource" do
      subject.get user, repo, number
      expect(a_get(request_path)).to have_been_made
    end

    it "should get pull_request information" do
      pull_request = subject.get user, repo, number
      expect(pull_request.number).to eq number
      expect(pull_request.head.user.login).to eq('octocat')
    end

    it "should return mash" do
      pull_request = subject.get user, repo, number
      expect(pull_request).to be_a Github::ResponseWrapper
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get user, repo, number }
  end
end # get
