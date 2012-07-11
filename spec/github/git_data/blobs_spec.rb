# encoding: utf-8

require 'spec_helper'

describe Github::GitData::Blobs do
  let(:github) { Github.new }
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:sha) { "3a0f86fb8db8eea7ccbb9a95f325ddbedfb25e15" }

  after { github.user, github.repo, github.oauth_token = nil, nil, nil }

  it { described_class::VALID_BLOB_PARAM_NAMES.should_not be_nil }

  describe "#get" do
    it { github.git_data.blobs.should respond_to :find }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/git/blobs/#{sha}").
          to_return(:body => fixture('git_data/blob.json'),
            :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without sha" do
        expect {
          github.git_data.blobs.get user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.git_data.blobs.get user, repo, sha
        a_get("/repos/#{user}/#{repo}/git/blobs/#{sha}").should have_been_made
      end

      it "should get blob information" do
        blob = github.git_data.blobs.get user, repo, sha
        blob.content.should eql "Content of the blob"
      end

      it "should return mash" do
        blob = github.git_data.blobs.get user, repo, sha
        blob.should be_a Hashie::Mash
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/git/blobs/#{sha}").
          to_return(:body => fixture('git_data/blob.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.git_data.blobs.get user, repo, sha
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # get

  describe "#create" do
    let(:inputs) {
      {
        "content" => "Content of the blob",
        "encoding" =>  "utf-8",
        "unrelated" => 'giberrish'
      }
    }

    context "resouce created" do
      before do
        stub_post("/repos/#{user}/#{repo}/git/blobs").
          with(inputs.except('unrelated')).
          to_return(:body => fixture('git_data/blob_sha.json'),
            :status => 201,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to create resource if 'content' input is missing" do
        expect {
          github.git_data.blobs.create user, repo, inputs.except('content')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should fail to create resource if 'encoding' input is missing" do
        expect {
          github.git_data.blobs.create user, repo, inputs.except('encoding')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should create resource successfully" do
        github.git_data.blobs.create user, repo, inputs
        a_post("/repos/#{user}/#{repo}/git/blobs").with(inputs).should have_been_made
      end

      it "should return the resource" do
        blob_sha = github.git_data.blobs.create user, repo, inputs
        blob_sha.should be_a Hashie::Mash
      end

      it "should get the blob information" do
        blob_sha = github.git_data.blobs.create user, repo, inputs
        blob_sha.sha.should == sha
      end
    end

    context "failed to create resource" do
      before do
        stub_post("/repos/#{user}/#{repo}/git/blobs").with(inputs).
          to_return(:body => fixture('git_data/blob_sha.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should faile to retrieve resource" do
        expect {
          github.git_data.blobs.create user, repo, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # create

end # Github::GitData::Blobs
