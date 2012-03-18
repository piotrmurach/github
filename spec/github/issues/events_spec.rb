# encoding: utf-8

require 'spec_helper'

describe Github::Issues::Events do
  let(:github) { Github.new }
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:issue_id) { 1 }

  after { reset_authentication_for github }

  describe '#list' do
    it { github.issues.comments.should respond_to :all }

    context 'without issue_id' do
      context "resource found" do
        before do
          stub_get("/repos/#{user}/#{repo}/issues/events").
            to_return(:body => fixture('issues/events.json'),
              :status => 200,
              :headers => {:content_type => "application/json; charset=utf-8"})
        end

        it "should fail to get resource without username" do
          expect { github.issues.events.list }.to raise_error(ArgumentError)
        end

        it "should get the resources" do
          github.issues.events.list user, repo
          a_get("/repos/#{user}/#{repo}/issues/events").should have_been_made
        end

        it "should return array of resources" do
          events = github.issues.events.list user, repo
          events.should be_an Array
          events.should have(1).items
        end

        it "should be a mash type" do
          events = github.issues.events.list user, repo
          events.first.should be_a Hashie::Mash
        end

        it "should get issue information" do
          events = github.issues.events.list user, repo
          events.first.actor.login.should == 'octocat'
        end

        it "should yield to a block" do
          github.issues.events.should_receive(:list).
            with(user, repo).and_yield('web')
          github.issues.events.list(user, repo) { |param| 'web' }.should == 'web'
        end
      end

      context "resource not found" do
        before do
          stub_get("/repos/#{user}/#{repo}/issues/events").
            to_return(:body => "", :status => [404, "Not Found"])
        end

        it "should return 404 with a message 'Not Found'" do
          expect {
            github.issues.events.list user, repo
          }.to raise_error(Github::Error::NotFound)
        end
      end
    end # without issue_id

    context 'with issue_id' do
      context "resource found" do
        before do
          stub_get("/repos/#{user}/#{repo}/issues/#{issue_id}/events").
            to_return(:body => fixture('issues/events.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
        end

        it "should get the resources" do
          github.issues.events.list user, repo, issue_id
          a_get("/repos/#{user}/#{repo}/issues/#{issue_id}/events").should have_been_made
        end

        it "should return array of resources" do
          events = github.issues.events.list user, repo, issue_id
          events.should be_an Array
          events.should have(1).items
        end

        it "should be a mash type" do
          events = github.issues.events.list user, repo, issue_id
          events.first.should be_a Hashie::Mash
        end

        it "should get issue information" do
          events = github.issues.events.list user, repo, issue_id
          events.first.actor.login.should == 'octocat'
        end

        it "should yield to a block" do
          github.issues.events.should_receive(:list).
            with(user, repo, issue_id).and_yield('web')
          github.issues.events.list(user, repo, issue_id) { |param| 'web' }.
            should == 'web'
        end
      end
    end # with issue_id
  end # list

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
