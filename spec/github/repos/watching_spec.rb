# encoding: utf-8

require 'spec_helper'

describe Github::Repos::Watching do

  let(:github) { Github.new }
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }

  describe "watchers" do
    before do
      stub_get("/repos/#{user}/#{repo}/watchers").
        to_return(:body => fixture("repos/watchers.json"), :status => 200, :headers => {})
    end

    it "should fail to get resource without username" do
      expect { github.repos.watchers }.to raise_error(ArgumentError)
    end

    it "should yield iterator if block given" do
      pending
      block = lambda { ['a', 'b', 'c'] }
      github.repos.watchers(user, repo, &block)
    end

    it "should get the resources" do
      github.repos.watchers(user, repo)
      a_get("/repos/#{user}/#{repo}/watchers").should have_been_made
    end

    it "should return array of resources" do
      watchers = github.repos.watchers(user, repo)
      watchers.should be_an Array
      watchers.should have(1).items
    end

    it "should get watcher information" do
      watchers = github.repos.watchers(user, repo)
      watchers.first.login.should == 'octocat'
    end

    context "fail to find resource" do
      before do
        stub_get("/repos/#{user}/#{repo}/watchers").
          to_return(:body => "", :status => 404)
      end

      it "should return 404 not found message" do
        lambda { github.repos.watchers(user, repo) }.should raise_error(Github::ResourceNotFound)
      end

    end

  end

  describe "watched" do

    context "if user unauthenticated" do
      before do
        stub_get("/users/#{user}/watched").
          to_return(:body => fixture("repos/watched.json"), :status => 401, :headers => {})

      end

      it "should fail to get resource without username " do
        expect {
          github.repos.watched
        }.to raise_error(Github::Unauthorised)
      end

      it "should get the resource with username" do
        github.user = user
        github.repos.watched(user)
        a_get("/user/#{user}/watched").should have_been_made
      end
    end

    context "if user authenticated" do
      before do
        github.oauth_token = OAUTH_TOKEN
        stub_get("/user/watched").
          to_return(:body => fixture("repos/watched.json"), :status => 200, :headers => {})
      end

      it "should get the resources" do
        github.repos.watched
        a_get("/user/watched?access_token=#{OAUTH_TOKEN}").should have_been_made
      end

      it "should return array of resources" do
        watched = github.repos.watched
        watched.should be_an Array
        watched.should have(1).items
      end

      it "should get watched information" do
        watched = github.repos.watched
        watched.first.name.should == 'Hello-World'
        watched.first.owner.login.should == 'octocat'
      end
    end
  end

  describe "watching?" do

    context "with username ane reponame passed" do

      context "this repo is being watched by the user"
        before do
          stub_get("/user/watched/#{user}/#{repo}").
            to_return(:body => "", :status => 404, :headers => {:user_agent => github.user_agent})
        end

      it "should return false if resource not found" do
        watching = github.repos.watching? user, repo
        watching.should be_false
      end

    end

    context "without username and reponame passed" do

    end
  end

  describe "start_watching" do
  end

  describe "stop_watching" do
  end

end # Github::Respos::Watching
