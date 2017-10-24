# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Comments, '#list' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }

  after { reset_authentication_for subject }

  context 'without sha' do
    let(:request_path) { "/repos/#{user}/#{repo}/comments" }

    before {
      stub_get(request_path).to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
    }

    context "resource found" do
      let(:body)   { fixture('repos/repo_comments.json') }
      let(:status) { 200 }

      it { should respond_to(:all) }

      it "should fail to get resource without username" do
        expect { subject.list }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        subject.list user, repo
        a_get(request_path).should have_been_made
      end

      it_should_behave_like 'an array of resources' do
        let(:requestable) { subject.list user, repo }
      end

      it "should get commit comment information" do
        repo_comments = subject.list user, repo
        repo_comments.first.user.login.should == 'octocat'
      end

      it "should yield to a block" do
        yielded = []
        result = subject.list(user, repo) { |obj| yielded << obj }
        yielded.should == result
      end
    end

    it_should_behave_like 'request failure' do
      let(:requestable) { subject.list user, repo }
    end

  end # without sha

  context 'with sha' do
    let(:sha) { '23432dfosfsufd' }
    let(:request_path) { "/repos/#{user}/#{repo}/commits/#{sha}/comments" }

    before {
      stub_get(request_path).to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
    }

    context "resource found" do
      let(:body) { fixture('repos/commit_comments.json') }
      let(:status) { 200 }

      it "should get the resource" do
        subject.list user, repo, :sha => sha
        a_get(request_path).should have_been_made
      end

      it_should_behave_like 'an array of resources' do
        let(:requestable) { subject.list user, repo, :sha => sha }
      end

      it "should get commit comment information" do
        commit_comments = subject.list user, repo, :sha => sha
        commit_comments.first.user.login.should == 'octocat'
      end

      it "should yield to a block" do
        yielded = []
        result = subject.list(user, repo, :sha => sha) { |obj| yielded << obj }
        yielded.should == result
      end
    end

    it_should_behave_like 'request failure' do
      let(:requestable) { subject.list user, repo, :sha => sha }
    end
  end # with sha
end # list
