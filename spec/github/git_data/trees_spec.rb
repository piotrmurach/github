# encoding: utf-8

require 'spec_helper'

describe Github::GitData::Trees do
  let(:github) { Github.new }
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:sha) { "9fb037999f264ba9a7fc6274d15fa3ae2ab98312" }

  after { github.user, github.repo, github.oauth_token = nil, nil, nil }

  it { described_class::VALID_TREE_PARAM_NAMES.should_not be_nil }

  describe "#get" do
    it { github.git_data.trees.should respond_to :find }

    context "non-resursive" do
      before do
        stub_get("/repos/#{user}/#{repo}/git/trees/#{sha}").
          to_return(:body => fixture('git_data/tree.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without sha" do
        expect {
          github.git_data.trees.get user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.git_data.trees.get user, repo, sha
        a_get("/repos/#{user}/#{repo}/git/trees/#{sha}").should have_been_made
      end

      it "should get tree information" do
        tree = github.git_data.trees.get user, repo, sha
        tree.sha.should eql sha
      end

      it "should return mash" do
        tree = github.git_data.trees.get user, repo, sha
        tree.should be_a Hashie::Mash
      end
    end

    context "resursive" do
      before do
        stub_get("/repos/#{user}/#{repo}/git/trees/#{sha}?recursive=1").
          to_return(:body => fixture('git_data/tree.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the resource" do
        github.git_data.trees.get user, repo, sha, 'recursive' => true
        a_get("/repos/#{user}/#{repo}/git/trees/#{sha}?recursive=1").should have_been_made
      end

      it "should get tree information" do
        tree = github.git_data.trees.get user, repo, sha, 'recursive' => true
        tree.sha.should eql sha
      end

      it "should return mash" do
        tree = github.git_data.trees.get user, repo, sha, 'recursive' => true
        tree.should be_a Hashie::Mash
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/git/trees/#{sha}").
          to_return(:body => fixture('git_data/tree.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.git_data.trees.get user, repo, sha
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # get

  describe "#create" do
    let(:inputs) {
      {
        "tree" => [
          {
            "path" => "file.rb",
            "mode" => "100644",
            "type" =>  "blob",
            "sha" => "44b4fc6d56897b048c772eb4087f854f46256132"
          }
        ]
      }
    }

    context "resouce created" do
      before do
        stub_post("/repos/#{user}/#{repo}/git/trees").
          with(inputs).
          to_return(:body => fixture('git_data/tree.json'),
            :status => 201,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to create resource if 'content' input is missing" do
        expect {
          github.git_data.trees.create user, repo, inputs.except('tree')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should create resource successfully" do
        github.git_data.trees.create user, repo, inputs
        a_post("/repos/#{user}/#{repo}/git/trees").with(inputs).should have_been_made
      end

      it "should return the resource" do
        tree_sha = github.git_data.trees.create user, repo, inputs
        tree_sha.should be_a Hashie::Mash
      end

      it "should get the tree information" do
        tree_sha = github.git_data.trees.create user, repo, inputs
        tree_sha.sha.should == sha
      end
    end

    context "failed to create resource" do
      before do
        stub_post("/repos/#{user}/#{repo}/git/trees").with(inputs).
          to_return(:body => fixture('git_data/tree.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should faile to retrieve resource" do
        expect {
          github.git_data.trees.create user, repo, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # create

end # Github::GitData::Trees
