require 'spec_helper'

describe Github::Repos::Hooks do

  let(:github) { Github.new }
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }

  describe "hooks" do
    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/hooks").
          to_return(:body => fixture('repos/hooks.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without username" do
        github.user, github.repo = nil, nil
        expect { github.repos.hooks }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.repos.hooks(user, repo)
        a_get("/repos/#{user}/#{repo}/hooks").should have_been_made
      end

      it "should return array of resources" do
        hooks = github.repos.hooks user, repo
        hooks.should be_an Array
        hooks.should have(1).items
      end

      it "should be a mash type" do
        hooks = github.repos.hooks user, repo
        hooks.first.should be_a Hashie::Mash
      end

      it "should get hook information" do
        hooks = github.repos.hooks(user, repo)
        hooks.first.name.should == 'web'
      end

      it "should yield to a block" do
        github.repos.should_receive(:hooks).with(user, repo).and_yield('web')
        github.repos.hooks(user, repo) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/hooks").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.repos.hooks user, repo
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end

  describe "hook" do
    let(:hook_id) { 1 }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/hooks/#{hook_id}").
          to_return(:body => fixture('repos/hook.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without hook id" do
        expect { github.repos.hook(user, repo, nil)}.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.repos.hook user, repo, hook_id
        a_get("/repos/#{user}/#{repo}/hooks/#{hook_id}").should have_been_made
      end

      it "should get hook information" do
        hook = github.repos.hook user, repo, hook_id
        hook.id.should == hook_id
        hook.name.should == 'web'
      end

      it "should return mash" do
        hook = github.repos.hook user, repo, hook_id
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
          github.repos.hook(user, repo, hook_id)
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end

  describe "create_hook" do
    let(:inputs) { {:name => 'web', :config => {:url => "http://something.com/webhook"}, :active => true}}

    context "resouce created" do
      before do
        stub_post("/repos/#{user}/#{repo}/hooks").with(inputs).
          to_return(:body => fixture('repos/hook.json'), :status => 201, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should fail to create resource if 'name' input is missing" do
        expect {
          github.repos.create_hook(user, repo, inputs.except(:name) )
        }.to raise_error(ArgumentError)
      end

      it "should failt to create resource if 'config' input is missing" do
        expect {
          github.repos.create_hook(user, repo, inputs.except(:config) )
        }.to raise_error(ArgumentError)
      end

      it "should create resource successfully" do
        github.repos.create_hook(user, repo, inputs)
        a_post("/repos/#{user}/#{repo}/hooks").with(inputs).should have_been_made
      end

      it "should get the hook information" do
        hook = github.repos.create_hook(user, repo, inputs)
        hook.name.should == 'web'
      end
    end

    context "failed to create resource" do
      before do
        stub_post("/repos/#{user}/#{repo}/hooks").with(inputs).
          to_return(:body => fixture('repos/hook.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should faile to retrieve resource" do
        expect {
          github.repos.create_hook(user, repo, inputs)
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end

  describe "edit_key" do

  end

  describe "delete_key" do

  end

  describe "test_hook" do

  end

end
