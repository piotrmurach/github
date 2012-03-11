# encoding: utf-8

require 'spec_helper'

describe Github::Events do
  let(:github) { Github.new }
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }

  after { github.user, github.repo, github.oauth_token = nil, nil, nil }

  describe "public" do
    context "resource found" do
      before do
        stub_get("/events").
          to_return(:body => fixture('events/events.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the resources" do
        github.events.public
        a_get("/events").should have_been_made
      end

      it "should return array of resources" do
        events = github.events.public
        events.should be_an Array
        events.should have(1).items
      end

      it "should be a mash type" do
        events = github.events.public
        events.first.should be_a Hashie::Mash
      end

      it "should get event information" do
        events = github.events.public
        events.first.type.should == 'Event'
      end

      it "should yield to a block" do
        github.events.should_receive(:public).and_yield('web')
        github.events.public { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/events").to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.events.public
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # public_events

  describe "repository" do
    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/events").
          to_return(:body => fixture('events/events.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without username" do
        expect { github.events.repository nil, repo }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.events.repository user, repo
        a_get("/repos/#{user}/#{repo}/events").should have_been_made
      end

      it "should return array of resources" do
        events = github.events.repository user, repo
        events.should be_an Array
        events.should have(1).items
      end

      it "should be a mash type" do
        events = github.events.repository user, repo
        events.first.should be_a Hashie::Mash
      end

      it "should get event information" do
        events = github.events.repository user, repo
        events.first.type.should == 'Event'
      end

      it "should yield to a block" do
        github.events.should_receive(:repository).with(user, repo).and_yield('web')
        github.events.repository(user, repo) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/events").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.events.repository user, repo
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # repository

  describe "issue" do
    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/issues/events").
          to_return(:body => fixture('events/events.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without username" do
        expect { github.events.issue nil, repo }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.events.issue user, repo
        a_get("/repos/#{user}/#{repo}/issues/events").should have_been_made
      end

      it "should return array of resources" do
        events = github.events.issue user, repo
        events.should be_an Array
        events.should have(1).items
      end

      it "should be a mash type" do
        events = github.events.issue user, repo
        events.first.should be_a Hashie::Mash
      end

      it "should get event information" do
        events = github.events.issue user, repo
        events.first.type.should == 'Event'
      end

      it "should yield to a block" do
        github.events.should_receive(:issue).with(user, repo).and_yield('web')
        github.events.issue(user, repo) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/issues/events").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.events.issue user, repo
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # repository

  describe "network" do
    context "resource found" do
      before do
        stub_get("/networks/#{user}/#{repo}/events").
          to_return(:body => fixture('events/events.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without username" do
        expect { github.events.network nil, repo }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.events.network user, repo
        a_get("/networks/#{user}/#{repo}/events").should have_been_made
      end

      it "should return array of resources" do
        events = github.events.network user, repo
        events.should be_an Array
        events.should have(1).items
      end

      it "should be a mash type" do
        events = github.events.network user, repo
        events.first.should be_a Hashie::Mash
      end

      it "should get event information" do
        events = github.events.network user, repo
        events.first.type.should == 'Event'
      end

      it "should yield to a block" do
        github.events.should_receive(:network).with(user, repo).and_yield('web')
        github.events.network(user, repo) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/networks/#{user}/#{repo}/events").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.events.network user, repo
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # network

  describe "org" do
    let(:org) { 'github' }
    context "resource found" do
      before do
        stub_get("/orgs/#{org}/events").
          to_return(:body => fixture('events/events.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without orgname" do
        expect { github.events.org nil }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.events.org org
        a_get("/orgs/#{org}/events").should have_been_made
      end

      it "should return array of resources" do
        events = github.events.org org
        events.should be_an Array
        events.should have(1).items
      end

      it "should be a mash type" do
        events = github.events.org org
        events.first.should be_a Hashie::Mash
      end

      it "should get event information" do
        events = github.events.org org
        events.first.type.should == 'Event'
      end

      it "should yield to a block" do
        github.events.should_receive(:org).with(org).and_yield('web')
        github.events.org(org) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/orgs/#{org}/events").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.events.org org
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # org

  describe "received" do
    context "resource found" do
      before do
        stub_get("/users/#{user}/received_events").
          to_return(:body => fixture('events/events.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without username" do
        expect { github.events.received nil }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.events.received user
        a_get("/users/#{user}/received_events").should have_been_made
      end

      it "should return array of resources" do
        events = github.events.received user
        events.should be_an Array
        events.should have(1).items
      end

      it "should be a mash type" do
        events = github.events.received user
        events.first.should be_a Hashie::Mash
      end

      it "should get event information" do
        events = github.events.received user
        events.first.type.should == 'Event'
      end

      it "should yield to a block" do
        github.events.should_receive(:received).with(user).and_yield('web')
        github.events.received(user) { |param| 'web' }
      end
    end

    context "all public resources found" do
      before do
        stub_get("/users/#{user}/received_events/public").
          to_return(:body => fixture('events/events.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the resources" do
        github.events.received user, :public => true
        a_get("/users/#{user}/received_events/public").should have_been_made
      end

      it "should return array of resources" do
        events = github.events.received user, :public => true
        events.should be_an Array
        events.should have(1).items
      end

      it "should be a mash type" do
        events = github.events.received user, :public => true
        events.first.should be_a Hashie::Mash
      end

      it "should get event information" do
        events = github.events.received user, :public => true
        events.first.type.should == 'Event'
      end

      it "should yield to a block" do
        github.events.should_receive(:received).with(user).and_yield('web')
        github.events.received(user) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/users/#{user}/received_events").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.events.received user
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # received

  describe "performed" do
    context "resource found" do
      before do
        stub_get("/users/#{user}/events").
          to_return(:body => fixture('events/events.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without username" do
        expect { github.events.performed nil }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.events.performed user
        a_get("/users/#{user}/events").should have_been_made
      end

      it "should return array of resources" do
        events = github.events.performed user
        events.should be_an Array
        events.should have(1).items
      end

      it "should be a mash type" do
        events = github.events.performed user
        events.first.should be_a Hashie::Mash
      end

      it "should get event information" do
        events = github.events.performed user
        events.first.type.should == 'Event'
      end

      it "should yield to a block" do
        github.events.should_receive(:performed).with(user).and_yield('web')
        github.events.performed(user) { |param| 'web' }
      end
    end

    context "all public resources found" do
      before do
        stub_get("/users/#{user}/events/public").
          to_return(:body => fixture('events/events.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the resources" do
        github.events.performed user, :public => true
        a_get("/users/#{user}/events/public").should have_been_made
      end

      it "should return array of resources" do
        events = github.events.performed user, :public => true
        events.should be_an Array
        events.should have(1).items
      end

      it "should be a mash type" do
        events = github.events.performed user, :public => true
        events.first.should be_a Hashie::Mash
      end

      it "should get event information" do
        events = github.events.performed user, :public => true
        events.first.type.should == 'Event'
      end

      it "should yield to a block" do
        github.events.should_receive(:performed).with(user).and_yield('web')
        github.events.performed(user) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/users/#{user}/events").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.events.performed user
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # performed

  describe "user_org" do
    let(:org) { 'github' }
    context "resource found" do
      before do
        stub_get("/users/#{user}/events/orgs/#{org}").
          to_return(:body => fixture('events/events.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without orgname" do
        expect { github.events.user_org user, nil }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.events.user_org user, org
        a_get("/users/#{user}/events/orgs/#{org}").should have_been_made
      end

      it "should return array of resources" do
        events = github.events.user_org user, org
        events.should be_an Array
        events.should have(1).items
      end

      it "should be a mash type" do
        events = github.events.user_org user, org
        events.first.should be_a Hashie::Mash
      end

      it "should get event information" do
        events = github.events.user_org user, org
        events.first.type.should == 'Event'
      end

      it "should yield to a block" do
        github.events.should_receive(:user_org).with(user, org).and_yield('web')
        github.events.user_org(user, org) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/users/#{user}/events/orgs/#{org}").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.events.user_org user, org
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # user_org

end # Github::Events
