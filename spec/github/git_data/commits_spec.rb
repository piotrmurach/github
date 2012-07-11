# encoding: utf-8

require 'spec_helper'

describe Github::GitData::Commits, :type => :base do
  let(:github) { Github.new }
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:sha) { "3a0f86fb8db8eea7ccbb9a95f325ddbedfb25e15" }

  after { github.user, github.repo, github.oauth_token = nil, nil, nil }

  it { described_class::VALID_COMMIT_PARAM_NAMES.should_not be_nil }

  describe "#get" do
    it { github.git_data.commits.should respond_to :find }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/git/commits/#{sha}").
          to_return(:body => fixture('git_data/commit.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without sha" do
        expect {
          github.git_data.commits.get user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.git_data.commits.get user, repo, sha
        a_get("/repos/#{user}/#{repo}/git/commits/#{sha}").should have_been_made
      end

      it "should get commit information" do
        commit = github.git_data.commits.get user, repo, sha
        commit.author.name.should eql "Scott Chacon"
      end

      it "should return mash" do
        commit = github.git_data.commits.get user, repo, sha
        commit.should be_a Hashie::Mash
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/git/commits/#{sha}").
          to_return(:body => fixture('git_data/commit.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.git_data.commits.get user, repo, sha
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # get

  describe "#create" do
    let(:inputs) {
      {
        "message" =>  "my commit message",
        "author" =>  {
          "name" =>  "Scott Chacon",
          "email" => "schacon@gmail.com",
          "date" => "2008-07-09T16:13:30+12:00"
         },
        "parents" => [
          "7d1b31e74ee336d15cbd21741bc88a537ed063a0"
        ],
        "tree" => "827efc6d56897b048c772eb4087f854f46256132",
        'unrelated' => 'giberrish'
      }
    }

    context "resouce created" do
      before do
        stub_post("/repos/#{user}/#{repo}/git/commits").
          with(inputs.except('unrelated')).
          to_return(:body => fixture('git_data/commit.json'), :status => 201, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to create resource if 'message' input is missing" do
        expect {
          github.git_data.commits.create user, repo, inputs.except('message')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should fail to create resource if 'tree' input is missing" do
        expect {
          github.git_data.commits.create user, repo, inputs.except('tree')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should fail to create resource if 'parents' input is missing" do
        expect {
          github.git_data.commits.create user, repo, inputs.except('parents')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should create resource successfully" do
        github.git_data.commits.create user, repo, inputs
        a_post("/repos/#{user}/#{repo}/git/commits").with(inputs).should have_been_made
      end

      it "should return the resource" do
        commit = github.git_data.commits.create user, repo, inputs
        commit.should be_a Hashie::Mash
      end

      it "should get the commit information" do
        commit = github.git_data.commits.create user, repo, inputs
        commit.author.name.should eql "Scott Chacon"
      end
    end

    context "failed to create resource" do
      before do
        stub_post("/repos/#{user}/#{repo}/git/commits").with(inputs).
          to_return(:body => fixture('git_data/commit.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should faile to retrieve resource" do
        expect {
          github.git_data.commits.create user, repo, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # create

end # Github::GitData::Commits
