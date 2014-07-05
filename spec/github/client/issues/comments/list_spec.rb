# encoding: utf-8

require 'spec_helper'

describe Github::Client::Issues::Comments, '#list' do
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let!(:number) { 1 }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "on an issue" do
    let(:request_path) { "/repos/#{user}/#{repo}/issues/#{number}/comments" }
    let(:body) { fixture('issues/comments.json') }
    let(:status) { 200 }

    it { should respond_to :all }

    it "should fail to get resource without username" do
      expect { subject.list user, nil }.to raise_error(ArgumentError)
    end

    it "should get the resources" do
      subject.list user, repo, :number => number
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list user, repo, :number => number }
    end

    it "should get issue comment information" do
      comments = subject.list user, repo, :number => number
      comments.first.user.login.should == 'octocat'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list(user, repo, :number => number) { |obj| yielded << obj }
      yielded.should == result
    end

    it_should_behave_like 'request failure' do
      let(:requestable) { subject.list user, repo, :number => number }
    end
  end

  context "in a repository" do
    let(:request_path) { "/repos/#{user}/#{repo}/issues/comments" }
    let(:body) { fixture('issues/comments.json') }
    let(:status) { 200 }

    it "should get the resources" do
      subject.list user, repo
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list user, repo }
    end

    it "should get issue comment information" do
      comments = subject.list user, repo
      comments.first.user.login.should == 'octocat'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list(user, repo) { |obj| yielded << obj }
      yielded.should == result
    end
  end
end # list
