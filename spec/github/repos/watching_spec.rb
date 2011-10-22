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
      github.user, github.repo = nil, nil
      expect { github.repos.watchers }.to raise_error(ArgumentError)
    end

    it "should yield iterator if block given" do
      github.repos.should_receive(:watchers).with(user, repo).and_yield('github')
      github.repos.watchers(user, repo) { |param| 'github' }
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

    it "should return result of mash type" do
      watchers = github.repos.watchers user, repo
      watchers.first.should be_a Hashie::Mash
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
        WebMock.reset!
      end

      it "should fail to get resource without username " do
        stub_get("/user/watched").
          to_return(:body => fixture("repos/watched.json"), :status => 401, :headers => {})
        expect {
          github.user = nil
          github.repos.watched
        }.to raise_error(Github::Unauthorised)
      end

      it "should get the resource with username" do
        stub_get("/users/#{user}/watched").
          to_return(:body => fixture("repos/watched.json"), :status => 200, :headers => {})
        github.repos.watched(user)
        a_get("/users/#{user}/watched").should have_been_made
      end
    end

    context "if user authenticated" do
      before do
        github.user = nil
        github.oauth_token = OAUTH_TOKEN
        stub_get("/user/watched?access_token=#{OAUTH_TOKEN}").
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
          github.oauth_token = nil
          github.user = nil
          stub_get("/user/watched/#{user}/#{repo}").
            to_return(:body => "", :status => 404, :headers => {:user_agent => github.user_agent})
        end

      it "should return false if resource not found" do
        watching = github.repos.watching? user, repo
        watching.should be_false
      end

      it "should return true if resoure found" do
          stub_get("/user/watched/#{user}/#{repo}").
            to_return(:body => "", :status => 200, :headers => {:user_agent => github.user_agent})
        watching = github.repos.watching? user, repo
        watching.should be_true
      end

    end

    context "without username and reponame passed" do
      it "should fail validation " do
        expect { github.repos.watching?(nil, nil) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "start_watching" do

    context "user authenticated" do

      context "with correct information" do
        before do
          github.user, github.repo = nil, nil
          github.oauth_token = OAUTH_TOKEN
          stub_put("/user/watched/#{user}/#{repo}?access_token=#{OAUTH_TOKEN}").
            to_return(:body => "", :status => 204, :headers => {})
        end

        it "should successfully watch a repo" do
          github.repos.start_watching(user, repo)
          a_put("/user/watched/#{user}/#{repo}?access_token=#{OAUTH_TOKEN}").should have_been_made
        end
      end

      context "without correct information" do

      end
    end

    context "user unauthenticated" do
      it "should fail" do
        github.oauth_token = nil
        stub_put("/user/watched/#{user}/#{repo}").
          to_return(:body => "", :status => 401, :headers => {})
        expect {
          github.repos.start_watching(user, repo)
        }.to raise_error(Github::Unauthorised)
      end
    end
  end

  describe "stop_watching" do

    context "user authenticated" do

      context "with correct information" do
        before do
          github.user, github.repo = nil, nil
          github.oauth_token = OAUTH_TOKEN
          stub_delete("/user/watched/#{user}/#{repo}?access_token=#{OAUTH_TOKEN}").
            to_return(:body => "", :status => 204, :headers => {})
        end

        it "should successfully watch a repo" do
          github.repos.stop_watching(user, repo)
          a_delete("/user/watched/#{user}/#{repo}?access_token=#{OAUTH_TOKEN}").should have_been_made
        end
      end

      context "without correct information" do

      end
    end

    context "user unauthenticated" do
      it "should fail" do
        github.oauth_token = nil
        stub_delete("/user/watched/#{user}/#{repo}").
          to_return(:body => "", :status => 401, :headers => {})
        expect {
          github.repos.stop_watching(user, repo)
        }.to raise_error(Github::Unauthorised)
      end
    end
  end

end # Github::Respos::Watching
