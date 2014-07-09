# encoding: utf-8

require 'spec_helper'

describe Github::Client::PullRequests::Comments, '#get' do
  let(:user)   { 'peter-murach' }
  let(:repo) { 'github' }
  let(:pull_request_id) { 1 }
  let(:number) { 1 }
  let(:request_path) { "/repos/#{user}/#{repo}/pulls/comments/#{number}" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context 'resource found' do
    let(:body) { fixture('pull_requests/comment.json') }
    let(:status) { 200 }

    it { should respond_to :find }

    it { expect { subject.get }.to raise_error(ArgumentError) }

    it "should fail to get resource without comment id" do
      expect { subject.get user, repo }.to raise_error(ArgumentError)
    end

    it "should get the resource" do
      subject.get user, repo, pull_request_id
      a_get(request_path).should have_been_made
    end

    it "should get comment information" do
      comment = subject.get user, repo, number
      comment.id.should eq number
      comment.user.login.should == 'octocat'
    end

    it "should return mash" do
      comment = subject.get user, repo, number
      comment.should be_a Github::ResponseWrapper
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get user, repo, number }
  end
end # get
