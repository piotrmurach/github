require 'spec_helper'

describe Github::Repos::Merging do
  let(:github) { Github.new }
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }

  after { github.user, github.repo, github.oauth_token = nil, nil, nil }

  describe "#merge" do
    let(:inputs) do
      {
        "base" => "master",
        "head" => "cool_feature",
        "commit_message" => "Shipped cool_feature!"
      }
    end

    context "resouce merged" do
      before do
        stub_post("/repos/#{user}/#{repo}/merges").with(inputs).
          to_return(:body => fixture('repos/merge.json'),
            :status => 201,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to merge resource if 'base' input is missing" do
        expect {
          github.repos.merging.merge user, repo, inputs.except('base')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should fail to create resource if 'head' input is missing" do
        expect {
          github.repos.merging.merge user, repo, inputs.except('head')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should merge resource successfully" do
        github.repos.merging.merge user, repo, inputs
        a_post("/repos/#{user}/#{repo}/merges").with(inputs).should have_been_made
      end

      it "should return the resource" do
        merge = github.repos.merging.merge user, repo, inputs
        merge.should be_a Hashie::Mash
      end

      it "should get the commit comment information" do
        merge = github.repos.merging.merge user, repo, inputs
        merge.commit.author.login.should == 'octocat'
      end
    end

    context "failed to create resource" do
      before do
        stub_post("/repos/#{user}/#{repo}/merges").with(inputs).
          to_return(:body => fixture('repos/merge.json'), 
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrieve resource" do
        expect {
          github.repos.merging.merge user, repo, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # merge

end # Github::Repos::Merging
