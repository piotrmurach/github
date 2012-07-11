# encoding: utf-8

require 'spec_helper'

describe Github::Repos::Hooks do
  let(:github) { Github.new }
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }

  after { github.user, github.repo, github.oauth_token = nil, nil, nil }

  it { described_class::VALID_HOOK_PARAM_NAMES.should_not be_nil }
  it { described_class::VALID_HOOK_PARAM_VALUES.should_not be_nil }
  it { described_class::REQUIRED_PARAMS.should_not be_nil }

  describe "#list" do
    it { github.repos.hooks.should respond_to :all }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/hooks").
          to_return(:body => fixture('repos/hooks.json'), :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without username" do
        expect { github.repos.hooks.list }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.repos.hooks.list user, repo
        a_get("/repos/#{user}/#{repo}/hooks").should have_been_made
      end

      it "should return array of resources" do
        hooks = github.repos.hooks.list user, repo
        hooks.should be_an Array
        hooks.should have(1).items
      end

      it "should be a mash type" do
        hooks = github.repos.hooks.list user, repo
        hooks.first.should be_a Hashie::Mash
      end

      it "should get hook information" do
        hooks = github.repos.hooks.list user, repo
        hooks.first.name.should == 'web'
      end

      it "should yield to a block" do
        github.repos.hooks.should_receive(:list).with(user, repo).and_yield('web')
        github.repos.hooks.list(user, repo) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/hooks").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.repos.hooks.list user, repo
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # list

  describe "#get" do
    let(:hook_id) { 1 }

    it { github.repos.hooks.should respond_to :find }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/hooks/#{hook_id}").
          to_return(:body => fixture('repos/hook.json'), :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without hook id" do
        expect {
          github.repos.hooks.get user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.repos.hooks.get user, repo, hook_id
        a_get("/repos/#{user}/#{repo}/hooks/#{hook_id}").should have_been_made
      end

      it "should get hook information" do
        hook = github.repos.hooks.get user, repo, hook_id
        hook.id.should == hook_id
        hook.name.should == 'web'
      end

      it "should return mash" do
        hook = github.repos.hooks.get user, repo, hook_id
        hook.should be_a Hashie::Mash
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/hooks/#{hook_id}").
          to_return(:body => fixture('repos/hook.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.repos.hooks.get user, repo, hook_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # get

  describe "#create" do
    let(:inputs) {
      {
        'name' => 'web',
        'config' => {
          'url' => "http://something.com/webhook",
          'address' => "test@example.com",
          'subdomain' => "github",
          'room' => "Commits",
          'token' => "abc123"
        },
        'active' => true,
        'unrelated' => true
      }
    }

    context "resouce created" do
      before do
        stub_post("/repos/#{user}/#{repo}/hooks").
          with(inputs.except('unrelated')).
          to_return(:body => fixture('repos/hook.json'),
            :status => 201,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to create resource if 'name' input is missing" do
        expect {
          github.repos.hooks.create user, repo, inputs.except('name')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should failt to create resource if 'config' input is missing" do
        expect {
          github.repos.hooks.create user, repo, inputs.except('config')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should create resource successfully" do
        github.repos.hooks.create user, repo, inputs
        a_post("/repos/#{user}/#{repo}/hooks").with(inputs).should have_been_made
      end

      it "should return the resource" do
        hook = github.repos.hooks.create user, repo, inputs
        hook.should be_a Hashie::Mash
      end

      it "should get the hook information" do
        hook = github.repos.hooks.create user, repo, inputs
        hook.name.should == 'web'
      end
    end

    context "fail to create resource" do
      before do
        stub_post("/repos/#{user}/#{repo}/hooks").with(inputs).
          to_return(:body => fixture('repos/hook.json'), :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrieve resource" do
        expect {
          github.repos.hooks.create user, repo, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # create

  describe "#edit" do
    let(:hook_id) { 1 }
    let(:inputs) {
      {
        :name => 'web',
        :config => {
          :url => "http://something.com/webhook",
          :address => "test@example.com",
          :subdomain => "github",
          :room => "Commits",
          :token => "abc123"
        },
        :active => true,
        :unrelated => true
      }
    }

    context "resource edited successfully" do
      before do
        stub_patch("/repos/#{user}/#{repo}/hooks/#{hook_id}").
          with(inputs.except(:unrelated)).
          to_return(:body => fixture("repos/hook.json"), :status => 200,
            :headers => { :content_type => "application/json; charset=utf-8"})
      end

      it "should fail to edit without 'user/repo' parameters" do
        expect { github.repos.hooks.edit }.to raise_error(ArgumentError)
      end

      it "should fail to edit resource without 'name' parameter" do
        expect{
          github.repos.hooks.edit user, repo, inputs.except(:name)
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should fail to edit resource without 'hook_id'" do
        expect {
          github.repos.hooks.edit user, repo
        }.to raise_error(ArgumentError)
      end

      it "should fail to edit resource without 'config' parameter" do
        expect {
          github.repos.hooks.edit user, repo, hook_id, inputs.except(:config)
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should edit the resource" do
        github.repos.hooks.edit user, repo, hook_id, inputs
        a_patch("/repos/#{user}/#{repo}/hooks/#{hook_id}").
          with(inputs).should have_been_made
      end

      it "should return resource" do
        hook = github.repos.hooks.edit user, repo, hook_id, inputs
        hook.should be_a Hashie::Mash
      end

      it "should be able to retrieve information" do
        hook = github.repos.hooks.edit user, repo, hook_id, inputs
        hook.name.should == 'web'
      end
    end

    context "failed to edit resource" do
      before do
        stub_patch("/repos/#{user}/#{repo}/hooks/#{hook_id}").with(inputs).
          to_return(:body => fixture("repos/hook.json"), :status => 404,
            :headers => { :content_type => "application/json; charset=utf-8"})
      end

      it "should fail to find resource" do
        expect {
          github.repos.hooks.edit user, repo, hook_id, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # edit

  describe "#delete" do
    let(:hook_id) { 1 }

    context "resource removed successfully" do
      before do
        stub_delete("/repos/#{user}/#{repo}/hooks/#{hook_id}").
          to_return(:body => '', :status => 204,
            :headers => { :content_type => "application/json; charset=utf-8"})
      end

      it "should fail to delete without 'user/repo' parameters" do
        expect { github.repos.hooks.delete }.to raise_error(ArgumentError)
      end

      it "should fail to delete resource without 'hook_id'" do
        expect {
          github.repos.hooks.delete user, repo
        }.to raise_error(ArgumentError)
      end

      it "should delete the resource" do
        github.repos.hooks.delete user, repo, hook_id
        a_delete("/repos/#{user}/#{repo}/hooks/#{hook_id}").should have_been_made
      end
    end

    context "failed to edit resource" do
      before do
        stub_delete("/repos/#{user}/#{repo}/hooks/#{hook_id}").
          to_return(:body => fixture("repos/hook.json"), :status => 404, :headers => { :content_type => "application/json; charset=utf-8"})
      end

      it "should fail to find resource" do
        expect {
          github.repos.hooks.delete user, repo, hook_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # delete

  describe "#test" do
    let(:hook_id) { 1 }

    context "resource tested successfully" do
      before do
        stub_post("/repos/#{user}/#{repo}/hooks/#{hook_id}/test").
          to_return(:body => '', :status => 204,
            :headers => { :content_type => "application/json; charset=utf-8"})
      end

      it "should fail to test without 'user/repo' parameters" do
        expect { github.repos.hooks.test }.to raise_error(ArgumentError)
      end

      it "should fail to test resource without 'hook_id'" do
        expect {
          github.repos.hooks.test user, repo
        }.to raise_error(ArgumentError)
      end

      it "should trigger test for the resource" do
        github.repos.hooks.test user, repo, hook_id
        a_post("/repos/#{user}/#{repo}/hooks/#{hook_id}/test").should have_been_made
      end
    end

    context "failed to test resource" do
      before do
        stub_post("/repos/#{user}/#{repo}/hooks/#{hook_id}/test").
          to_return(:body => '', :status => 404,
            :headers => { :content_type => "application/json; charset=utf-8"})
      end

      it "should fail to find resource" do
        expect {
          github.repos.hooks.test user, repo, hook_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # test

end # Github::Repos::Hooks
