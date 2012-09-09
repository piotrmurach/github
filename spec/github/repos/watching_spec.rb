# encoding: utf-8

require 'spec_helper'

describe Github::Repos::Watching do
  let(:github) { Github.new }
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }

  after { github.user, github.repo, github.oauth_token = nil, nil, nil }

  describe "#list" do
    before do
      stub_get("/repos/#{user}/#{repo}/subscribers").
        to_return(:body => fixture("repos/watchers.json"),
                  :status => 200, :headers => {})
    end

    it "should fail to get resource without username" do
      expect {
        github.repos.watching.list
      }.to raise_error(ArgumentError)
    end

    it "should yield iterator if block given" do
      github.repos.watching.should_receive(:list).
        with(user, repo).and_yield('github')
      github.repos.watching.list(user, repo) { |param| 'github' }
    end

    it "should get the resources" do
      github.repos.watching.list user, repo
      a_get("/repos/#{user}/#{repo}/subscribers").should have_been_made
    end

    it "should return array of resources" do
      watchers = github.repos.watching.list user, repo
      watchers.should be_an Array
      watchers.should have(1).items
    end

    it "should return result of mash type" do
      watchers = github.repos.watching.list user, repo
      watchers.first.should be_a Hashie::Mash
    end

    it "should get watcher information" do
      watchers = github.repos.watching.list user, repo
      watchers.first.login.should == 'octocat'
    end

    context "fail to find resource" do
      before do
        stub_get("/repos/#{user}/#{repo}/subscribers").
          to_return(:body => "", :status => 404)
      end

      it "should return 404 not found message" do
        expect {
          github.repos.watching.list user, repo
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # list

  describe "#watched" do
    context "if user unauthenticated" do
      it "should fail to get resource without username " do
        stub_get("/user/subscriptions").
          to_return(:body => '', :status => 401, :headers => {})
        expect {
          github.repos.watching.watched
        }.to raise_error(Github::Error::Unauthorized)
      end

      it "should get the resource with username" do
        stub_get("/users/#{user}/subscriptions").
          to_return(:body => fixture("repos/watched.json"), :status => 200, :headers => {})
        github.repos.watching.watched :user => user
        a_get("/users/#{user}/subscriptions").should have_been_made
      end
    end

    context "if user authenticated" do
      before do
        github.oauth_token = OAUTH_TOKEN
        stub_get("/user/subscriptions").
          with(:query => {:access_token => OAUTH_TOKEN}).
          to_return(:body => fixture("repos/watched.json"), :status => 200, :headers => {})
      end

      it "should get the resources" do
        github.repos.watching.watched
        a_get("/user/subscriptions").
          with(:query => {:access_token => OAUTH_TOKEN}).
          should have_been_made
      end

      it "should return array of resources" do
        watched = github.repos.watching.watched
        watched.should be_an Array
        watched.should have(1).items
      end

      it "should get watched information" do
        watched = github.repos.watching.watched
        watched.first.name.should == 'Hello-World'
        watched.first.owner.login.should == 'octocat'
      end
    end
  end # watched

  describe "watching?" do
    context "with username ane reponame passed" do
      context "this repo is being watched by the user"
        before do
          stub_get("/user/subscriptions/#{user}/#{repo}").
            to_return(:body => "", :status => 404,
                      :headers => {:user_agent => github.user_agent})
        end

      it "should return false if resource not found" do
        watching = github.repos.watching.watching? user, repo
        watching.should be_false
      end

      it "should return true if resoure found" do
          stub_get("/user/subscriptions/#{user}/#{repo}").
            to_return(:body => "", :status => 200,
              :headers => {:user_agent => github.user_agent})
        watching = github.repos.watching.watching? user, repo
        watching.should be_true
      end
    end

    context "without username and reponame passed" do
      it "should fail validation " do
        expect {
          github.repos.watching.watching?(nil, nil)
        }.to raise_error(ArgumentError)
      end
    end
  end # watching?

  describe "#watch" do
    context "user authenticated" do
      context "with correct information" do
        before do
          github.oauth_token = OAUTH_TOKEN
          stub_put("/user/subscriptions/#{user}/#{repo}").
            with(:query => {:access_token => OAUTH_TOKEN}).
            to_return(:body => "", :status => 204, :headers => {})
        end

        it "should successfully watch a repo" do
          github.repos.watching.watch user, repo
          a_put("/user/subscriptions/#{user}/#{repo}").
            with(:query => {:access_token => OAUTH_TOKEN}).
            should have_been_made
        end
      end
    end

    context "user unauthenticated" do
      it "should fail" do
        stub_put("/user/subscriptions/#{user}/#{repo}").
          to_return(:body => "", :status => 401, :headers => {})
        expect {
          github.repos.watching.watch user, repo
        }.to raise_error(Github::Error::Unauthorized)
      end
    end
  end # watch

  describe "#unwatch" do
    context "user authenticated" do
      context "with correct information" do
        before do
          github.oauth_token = OAUTH_TOKEN
          stub_delete("/user/subscriptions/#{user}/#{repo}?access_token=#{OAUTH_TOKEN}").
            to_return(:body => "", :status => 204, :headers => {})
        end

        it "should successfully watch a repo" do
          github.repos.watching.unwatch user, repo
          a_delete("/user/subscriptions/#{user}/#{repo}?access_token=#{OAUTH_TOKEN}").
            should have_been_made
        end
      end
    end

    context "user unauthenticated" do
      it "should fail" do
        stub_delete("/user/subscriptions/#{user}/#{repo}").
          to_return(:body => "", :status => 401, :headers => {})
        expect {
          github.repos.watching.unwatch user, repo
        }.to raise_error(Github::Error::Unauthorized)
      end
    end
  end # unwatch

end # Github::Respos::Watching
