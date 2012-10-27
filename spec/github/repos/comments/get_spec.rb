# encoding: utf-8

require 'spec_helper'

describe Github::Repos::Comments, '#get' do
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

    it { should respond_to(:find) }

    it "should fail to get resource without comment id" do
      expect { subject.get user, repo, nil }.to raise_error(ArgumentError)
    end

    it "should get the resource" do
      subject.get user, repo, comment_id
      a_get(request_path).should have_been_made
    end

    it "should get commit comment information" do
      commit_comment = subject.get user, repo, comment_id
      commit_comment.user.login.should == 'octocat'
    end

    it "should return mash" do
      commit_comment = subject.get user, repo, comment_id
      commit_comment.should be_a Hashie::Mash
    end
  end

  context "resource not found" do
    let(:body)   { '' }
    let(:status) { 404 }

    it "should fail to retrive resource" do
      expect {
        subject.get user, repo, comment_id
      }.to raise_error(Github::Error::NotFound)
    end
  end
end # get
