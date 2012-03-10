require 'spec_helper'

describe Github::Repos::Keys do
  let(:github) { Github.new }
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }

  after { github.user, github.repo = nil, nil}

  it { described_class::VALID_KEY_PARAM_NAMES.should_not be_nil }

  describe "keys" do
    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/keys").
          to_return(:body => fixture("repos/keys.json"), :status => 200, :headers => {})
      end

      it "should fail to get resource without username" do
        expect { github.repos.keys }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.repos.keys(user, repo)
        a_get("/repos/#{user}/#{repo}/keys").should have_been_made
      end

      it "should return array of resources" do
        keys = github.repos.keys(user, repo)
        keys.should be_an Array
        keys.should have(1).items
      end

      it "should get key information" do
        keys = github.repos.keys(user, repo)
        keys.first.title.should == 'octocat@octomac'
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/keys").
          to_return(:body => fixture("repos/keys.json"), :status => 404)
      end

      it "should fail to retrieve resource" do
        expect {
          github.repos.keys user, repo
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end

  describe "get_key" do
    let(:key_id) { 1 }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/keys/#{key_id}").
          to_return(:body => fixture("repos/key.json"), :status => 200)
      end

      it "should fail to get resource without key" do
        expect {
          github.repos.get_key(user, repo, nil)
        }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.repos.get_key(user, repo, key_id)
        a_get("/repos/#{user}/#{repo}/keys/#{key_id}").should have_been_made
      end

      it "should get key information" do
        key = github.repos.get_key(user, repo, key_id)
        key.id.should == key_id
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/keys/#{key_id}").
          to_return(:body => fixture("repos/keys.json"), :status => 404)
      end

      it "should fail to retrieve resource" do
        expect {
          github.repos.get_key(user, repo, key_id)
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end

  describe "create_key" do
    let(:inputs) { {:title => "octocat@octomac", :key => "ssh-rsa AAA..." } }

    context "resource created" do
      before do
        stub_post("/repos/#{user}/#{repo}/keys").with(inputs).
          to_return(:body => fixture("repos/key.json"), :status => 201)
      end

      it "should fail to create resource if 'title' input is missing" do
        expect {
          github.repos.create_key(user, repo, :key => 'ssh-rsa AAA...')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should fail to create resource if 'key' input is missing" do
        expect {
          github.repos.create_key(user, repo, :title => 'octocat@octomac')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should create the resource" do
        github.repos.create_key(user, repo, inputs)
        a_post("/repos/#{user}/#{repo}/keys").with(inputs).should have_been_made
      end

      it "should get the key information back" do
        key = github.repos.create_key(user, repo, inputs)
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
          github.repos.create_key(user, repo, inputs)
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end

  describe "edit_key" do
    let(:key_id) { 1 }
    let(:inputs) { {:title => "octocat@octomac", :key => "ssh-rsa AAA..." } }

    context "resource edited successfully" do
      before do
        stub_patch("/repos/#{user}/#{repo}/keys/#{key_id}").
          to_return(:body => fixture("repos/key.json"), :status => 200)
      end

      it "should edit the resource" do
        github.repos.edit_key(user, repo, key_id, inputs)
        a_patch("/repos/#{user}/#{repo}/keys/#{key_id}").should have_been_made
      end

      it "should get the key information back" do
        key = github.repos.edit_key(user, repo, key_id, inputs)
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
          github.repos.edit_key(user, repo, key_id, inputs)
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end

  describe "delete_key" do
    let(:key_id) { 1 }

    context "resource found successfully" do
      before do
        stub_delete("/repos/#{user}/#{repo}/keys/#{key_id}").
          to_return(:body => "", :status => 204, :headers => { :content_type => "application/json; charset=utf-8"} )
      end

      it "should fail to delete without 'user/repo' parameters" do
        github.user, github.repo = nil, nil
        expect { github.repos.delete_key }.to raise_error(ArgumentError)
      end

      it "should fail to delete resource without key id" do
        expect {
          github.repos.delete_key user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should delete the resource" do
        github.repos.delete_key(user, repo, key_id)
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
          github.repos.delete_key(user, repo, key_id)
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end

end # Github::Repos::Keys
