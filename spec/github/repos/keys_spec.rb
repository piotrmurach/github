require 'spec_helper'

describe Github::Repos::Keys do
  let(:github) { Github.new }
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }

  after { github.user, github.repo, github.oauth_token = nil, nil, nil }

  it { described_class::VALID_KEY_PARAM_NAMES.should_not be_nil }

  describe "#list" do
    it { github.repos.keys.should respond_to :all }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/keys").
          to_return(:body => fixture("repos/keys.json"),
            :status => 200, :headers => {})
      end

      it "should fail to get resource without username" do
        expect { github.repos.keys.list }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.repos.keys.list user, repo
        a_get("/repos/#{user}/#{repo}/keys").should have_been_made
      end

      it "should return array of resources" do
        keys = github.repos.keys.list user, repo
        keys.should be_an Array
        keys.should have(1).items
      end

      it "should get key information" do
        keys = github.repos.keys.list user, repo
        keys.first.title.should == 'octocat@octomac'
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/keys").
          to_return(:body => '', :status => 404)
      end

      it "should fail to retrieve resource" do
        expect {
          github.repos.keys.list user, repo
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # list

  describe "#get" do
    let(:key_id) { 1 }

    it { github.repos.keys.should respond_to :find }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/keys/#{key_id}").
          to_return(:body => fixture("repos/key.json"), :status => 200)
      end

      it "should fail to get resource without key" do
        expect {
          github.repos.keys.get user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.repos.keys.get user, repo, key_id
        a_get("/repos/#{user}/#{repo}/keys/#{key_id}").should have_been_made
      end

      it "should get key information" do
        key = github.repos.keys.get user, repo, key_id
        key.id.should == key_id
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/keys/#{key_id}").
          to_return(:body => '', :status => 404)
      end

      it "should fail to retrieve resource" do
        expect {
          github.repos.keys.get user, repo, key_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # get

  describe "#create" do
    let(:inputs) { {:title => "octocat@octomac", :key => "ssh-rsa AAA..." } }

    context "resource created" do
      before do
        stub_post("/repos/#{user}/#{repo}/keys").with(inputs).
          to_return(:body => fixture("repos/key.json"), :status => 201)
      end

      it "should fail to create resource if 'title' input is missing" do
        expect {
          github.repos.keys.create user, repo, :key => 'ssh-rsa AAA...'
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should fail to create resource if 'key' input is missing" do
        expect {
          github.repos.keys.create user, repo, :title => 'octocat@octomac'
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should create the resource" do
        github.repos.keys.create user, repo, inputs
        a_post("/repos/#{user}/#{repo}/keys").with(inputs).should have_been_made
      end

      it "should get the key information back" do
        key = github.repos.keys.create user, repo, inputs
        key.title.should == 'octocat@octomac'
      end
    end

    context "failed to create resource" do
      before do
        stub_post("/repos/#{user}/#{repo}/keys").
          to_return(:body => fixture("repos/key.json"), :status => 404)
      end

      it "should fail to retrieve resource" do
        expect {
          github.repos.keys.create user, repo, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # create

  describe "#edit" do
    let(:key_id) { 1 }
    let(:inputs) { {:title => "octocat@octomac", :key => "ssh-rsa AAA..." } }

    context "resource edited successfully" do
      before do
        stub_patch("/repos/#{user}/#{repo}/keys/#{key_id}").
          to_return(:body => fixture("repos/key.json"), :status => 200)
      end

      it "should edit the resource" do
        github.repos.keys.edit user, repo, key_id, inputs
        a_patch("/repos/#{user}/#{repo}/keys/#{key_id}").should have_been_made
      end

      it "should get the key information back" do
        key = github.repos.keys.edit user, repo, key_id, inputs
        key.id.should == key_id
        key.title.should == 'octocat@octomac'
      end
    end

    context "failed to edit resource" do
      before do
        stub_patch("/repos/#{user}/#{repo}/keys/#{key_id}").
          to_return(:body => fixture("repos/key.json"), :status => 404)
      end

      it "should fail to retrieve resource" do
        expect {
          github.repos.keys.edit user, repo, key_id, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # edit

  describe "#delete" do
    let(:key_id) { 1 }

    context "resource found successfully" do
      before do
        stub_delete("/repos/#{user}/#{repo}/keys/#{key_id}").
          to_return(:body => "", :status => 204,
            :headers => { :content_type => "application/json; charset=utf-8"} )
      end

      it "should fail to delete without 'user/repo' parameters" do
        expect { github.repos.keys.delete }.to raise_error(ArgumentError)
      end

      it "should fail to delete resource without key id" do
        expect {
          github.repos.keys.delete user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should delete the resource" do
        github.repos.keys.delete user, repo, key_id
        a_delete("/repos/#{user}/#{repo}/keys/#{key_id}").should have_been_made
      end
    end

    context "failed to find resource" do
      before do
        stub_delete("/repos/#{user}/#{repo}/keys/#{key_id}").
          to_return(:body => "", :status => 404)
      end
      it "should fail to find resource" do
        expect {
          github.repos.keys.delete user, repo, key_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # delete

end # Github::Repos::Keys
