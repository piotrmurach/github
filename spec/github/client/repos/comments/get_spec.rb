# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Comments, '#get' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:comment_id) { 1 }
  let(:request_path) { "/repos/#{user}/#{repo}/comments/#{comment_id}" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  context "resource found" do
    let(:body)   { fixture('repos/commit_comment.json') }
    let(:status) { 200 }

    it { is_expected.to respond_to(:find) }

    it 'failse to get resource without required arguments' do
      expect { subject.get }.to raise_error(ArgumentError)
    end

    it 'fails to get resource without all required arguments' do
      expect { subject.get user }.to raise_error(ArgumentError)
    end

    it "should get the resource" do
      subject.get user, repo, comment_id
      expect(a_get(request_path)).to have_been_made
    end

    it "should get commit comment information" do
      commit_comment = subject.get user, repo, comment_id
      expect(commit_comment.user.login).to eq 'octocat'
    end

    it "should return mash" do
      commit_comment = subject.get user, repo, comment_id
      expect(commit_comment).to be_a Github::ResponseWrapper
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get user, repo, comment_id }
  end
end # get
