# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::PullRequests::Comments, '#delete' do
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:number) { 1 }

  let(:request_path) { "/repos/#{user}/#{repo}/pulls/comments/#{number}" }
  let(:status) { 204 }
  let(:body) { fixture('pull_requests/comment.json') }

  before {
    stub_delete(request_path).to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context 'resource removed' do
    it 'raises error if number not present' do
      expect { subject.delete(user, repo) }.to raise_error(ArgumentError)
    end

    it "removes resource successfully" do
      subject.delete user, repo, number
      expect(a_delete(request_path)).to have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.delete(user, repo, number) }
  end
end # delete
