# encoding: utf-8

require 'spec_helper'

describe Github::Client::Issues::Comments, '#get' do
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let!(:comment_id) { 1 }
  let(:request_path) { "/repos/#{user}/#{repo}/issues/comments/#{comment_id}" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body) { fixture('issues/comment.json') }
    let(:status) { 200 }

    it { is_expected.to respond_to :find }

    it "should fail to get resource without comment id" do
      expect { subject.get user, repo, nil }.to raise_error(ArgumentError)
    end

    it "should get the resource" do
      subject.get user, repo, comment_id
      expect(a_get(request_path)).to have_been_made
    end

    it "should get comment information" do
      comment = subject.get user, repo, comment_id
      expect(comment.user.id).to eq comment_id
      expect(comment.user.login).to eq 'octocat'
    end

    it "should return mash" do
      comment = subject.get user, repo, comment_id
      expect(comment).to be_a Github::ResponseWrapper
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get user, repo, comment_id }
  end
end # get
