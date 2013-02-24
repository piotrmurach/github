
# encoding: utf-8

require 'spec_helper'

describe Github::Issues::Events, '#list' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:issue_id) { 1 }
  let(:request_path) { "/repos/#{user}/#{repo}/issues/events" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context 'without issue_id' do
    let(:body) { fixture('issues/events.json') }
    let(:status) { 200 }

    context "resource found" do

      it { subject.should respond_to :all }

      it { expect { subject.list }.to raise_error(ArgumentError) }

      it "should fail to get resource without username" do
        expect { subject.list user }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        subject.list user, repo
        a_get(request_path).should have_been_made
      end

      it_should_behave_like 'an array of resources' do
        let(:requestable) { subject.list user, repo }
      end

      it "should get issue information" do
        events = subject.list user, repo
        events.first.actor.login.should == 'octocat'
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
  end # without issue_id

  context 'with issue_id' do
    let(:request_path) { "/repos/#{user}/#{repo}/issues/#{issue_id}/events" }
    let(:body) { fixture('issues/events.json') }
    let(:status) { 200 }

    context "resource found" do
      it "should get the resources" do
        subject.list user, repo, :issue_id => issue_id
        a_get(request_path).should have_been_made
      end

      it_should_behave_like 'an array of resources' do
        let(:requestable) { subject.list user, repo, :issue_id => issue_id }
      end

      it "should get issue information" do
        events = subject.list user, repo, :issue_id => issue_id
        events.first.actor.login.should == 'octocat'
      end

      it "should yield to a block" do
        yielded = []
        result = subject.list(user, repo, :issue_id => issue_id) { |obj| yielded << obj }
        yielded.should == result
      end
    end
  end # with issue_id
end # list
