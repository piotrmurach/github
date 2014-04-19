# encoding: utf-8

require 'spec_helper'

describe Github::Client::PullRequests, '#merge' do
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:number) { 1347 }
  let(:request_path) { "/repos/#{user}/#{repo}/pulls/#{number}/merge" }

  before {
    stub_put(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context 'successful' do
    let(:body) { fixture('pull_requests/merge_success.json') }
    let(:status) { 200 }

    it { expect { subject.merge }.to raise_error(ArgumentError) }

    it 'performs request' do
      subject.merge user, repo, number
      a_put(request_path).should have_been_made
    end

    it 'response contains merge success flag' do
      response = subject.merge(user, repo, number)
      response.merged.should be_true
    end
  end

  context 'cannot be performed' do
    let(:body) { fixture('pull_requests/merge_failure.json') }
    let(:status) { 200 }

    it 'response contains merge failure flag' do
      response = subject.merge(user, repo, number)
      response.merged.should be_false
    end
  end
end # merge
