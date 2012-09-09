# encoding: utf-8

require 'spec_helper'

describe Github::Repos::Starring do
  let(:github) { Github.new }
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }

  after { github.user, github.repo, github.oauth_token = nil, nil, nil }

  describe "#list" do
    before do
      stub_get("/repos/#{user}/#{repo}/stargazers").
        to_return(:body => fixture("repos/stargazers.json"),
                  :status => 200, :headers => {})
    end

    it "should fail to get resource without username" do
      expect {
        github.repos.starring.list
      }.to raise_error(ArgumentError)
    end

    it "should yield iterator if block given" do
      github.repos.starring.should_receive(:list).
        with(user, repo).and_yield('github')
      github.repos.starring.list(user, repo) { |param| 'github' }
    end

    it "should get the resources" do
      github.repos.starring.list user, repo
      a_get("/repos/#{user}/#{repo}/stargazers").should have_been_made
    end

    it "should return array of resources" do
      stargazers = github.repos.starring.list user, repo
      stargazers.should be_an Array
      stargazers.should have(1).items
    end

    it "should return result of mash type" do
      stargazers = github.repos.starring.list user, repo
      stargazers.first.should be_a Hashie::Mash
    end

    it "should get watcher information" do
      stargazers = github.repos.starring.list user, repo
      stargazers.first.login.should == 'octocat'
    end

    context "fail to find resource" do
      before do
        stub_get("/repos/#{user}/#{repo}/stargazers").
          to_return(:body => "", :status => 404)
      end

      it "should return 404 not found message" do
        expect {
          github.repos.starring.list user, repo
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end

  describe "#starred" do
    context "if user unauthenticated" do
      it "should fail to get resource without username " do
        stub_get("/user/starred").
          to_return(:body => '', :status => 401, :headers => {})
        expect {
          github.repos.starring.starred
        }.to raise_error(Github::Error::Unauthorized)
      end

      it "should get the resource with username" do
        stub_get("/users/#{user}/starred").
          to_return(:body => fixture("repos/starred.json"), :status => 200, :headers => {})
        github.repos.starring.starred :user => user
        a_get("/users/#{user}/starred").should have_been_made
      end
    end

    context "if user authenticated" do
      before do
        github.oauth_token = OAUTH_TOKEN
        stub_get("/user/starred").
          with(:query => {:access_token => OAUTH_TOKEN}).
          to_return(:body => fixture("repos/starred.json"),
            :status => 200, :headers => {})
      end

      it "should get the resources" do
        github.repos.starring.starred
        a_get("/user/starred").with(:query => {:access_token => OAUTH_TOKEN}).
          should have_been_made
      end

      it "should return array of resources" do
        starred = github.repos.starring.starred
        starred.should be_an Array
        starred.should have(1).items
      end

      it "should get starred information" do
        starred = github.repos.starring.starred
        starred.first.name.should == 'Hello-World'
        starred.first.owner.login.should == 'octocat'
      end
    end
  end # starred

  describe "starring?" do
    context "with username ane reponame passed" do
      context "this repo is being watched by the user"
        before do
          stub_get("/user/starred/#{user}/#{repo}").
            to_return(:body => "", :status => 404,
                      :headers => {:user_agent => github.user_agent})
        end

      it "should return false if resource not found" do
        starring = github.repos.starring.starring? user, repo
        starring.should be_false
      end

      it "should return true if resoure found" do
          stub_get("/user/starred/#{user}/#{repo}").
            to_return(:body => "", :status => 200,
            :headers => {:user_agent => github.user_agent})
        starring = github.repos.starring.starring? user, repo
        starring.should be_true
      end
    end

    context "without username and reponame passed" do
      it "should fail validation " do
        expect {
          github.repos.starring.starring?(nil, nil)
        }.to raise_error(ArgumentError)
      end
    end
  end # starring?

  describe "#star" do
    context "user authenticated" do
      context "with correct information" do
        before do
          github.oauth_token = OAUTH_TOKEN
          stub_put("/user/starred/#{user}/#{repo}").
            with(:query => {:access_token => OAUTH_TOKEN}).
            to_return(:body => "", :status => 204, :headers => {})
        end

        it "should successfully star a repo" do
          github.repos.starring.star user, repo
          a_put("/user/starred/#{user}/#{repo}").
            with(:query => {:access_token => OAUTH_TOKEN}).
            should have_been_made
        end
      end
    end

    context "user unauthenticated" do
      it "should fail" do
        stub_put("/user/starred/#{user}/#{repo}").
          to_return(:body => "", :status => 401, :headers => {})
        expect {
          github.repos.starring.star user, repo
        }.to raise_error(Github::Error::Unauthorized)
      end
    end
  end # star

  describe "#unstar" do
    context "user authenticated" do
      context "with correct information" do
        before do
          github.oauth_token = OAUTH_TOKEN
          stub_delete("/user/starred/#{user}/#{repo}?access_token=#{OAUTH_TOKEN}").
            to_return(:body => "", :status => 204, :headers => {})
        end

        it "should successfully unstar a repo" do
          github.repos.starring.unstar user, repo
          a_delete("/user/starred/#{user}/#{repo}?access_token=#{OAUTH_TOKEN}").
            should have_been_made
        end
      end
    end

    context "user unauthenticated" do
      it "should fail" do
        stub_delete("/user/starred/#{user}/#{repo}").
          to_return(:body => "", :status => 401, :headers => {})
        expect {
          github.repos.starring.unstar user, repo
        }.to raise_error(Github::Error::Unauthorized)
      end
    end
  end # stop_watching

end # Github::Respos::Starring
