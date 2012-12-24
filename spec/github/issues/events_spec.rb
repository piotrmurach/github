# encoding: utf-8

require 'spec_helper'

describe Github::Issues::Events do
  let(:github) { Github.new }
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:issue_id) { 1 }

  after { reset_authentication_for github }

  describe "#get" do
    let(:event_id) { 1 }

    it { github.issues.events.should respond_to :find }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/issues/events/#{event_id}").
          to_return(:body => fixture('issues/event.json'),
            :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without event id" do
        expect {
          github.issues.events.get user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.issues.events.get user, repo, event_id
        a_get("/repos/#{user}/#{repo}/issues/events/#{event_id}").
          should have_been_made
      end

      it "should get event information" do
        event = github.issues.events.get user, repo, event_id
        event.actor.id.should == event_id
        event.actor.login.should == 'octocat'
      end

      it "should return mash" do
        event = github.issues.events.get user, repo, event_id
        event.should be_a Hashie::Mash
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/issues/events/#{event_id}").
          to_return(:body => fixture('issues/event.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.issues.events.get user, repo, event_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # get

end # Github::Issues:Events
