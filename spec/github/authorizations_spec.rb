# encoding: utf-8

require 'spec_helper'

describe Github::Authorizations do
  let(:github) { Github.new }
  let(:basic_auth) { 'login:password' }

  before do
    github.basic_auth = basic_auth
  end

  after do
    reset_authentication_for github
  end

  describe "authorizations" do
    it { github.authorizations.should respond_to :all }

    context "resource found" do
      before do
        stub_get("/authorizations", "https://#{basic_auth}@api.github.com").
          to_return(:body => fixture('auths/authorizations.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end


      it "should fail to get resource without basic authentication" do
        reset_authentication_for github
        expect { github.oauth.list }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.oauth.list
        a_get("/authorizations", "https://#{basic_auth}@api.github.com").should have_been_made
      end

      it "should return array of resources" do
        authorizations = github.oauth.list
        authorizations.should be_an Array
        authorizations.should have(1).items
      end

      it "should be a mash type" do
        authorizations = github.oauth.list
        authorizations.first.should be_a Hashie::Mash
      end

      it "should get authorization information" do
        authorizations = github.oauth.list
        authorizations.first.token.should == 'abc123'
      end

      it "should yield to a block" do
        github.oauth.should_receive(:list).and_yield('web')
        github.oauth.list { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/authorizations", "https://#{basic_auth}@api.github.com").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect { github.oauth.list }.to raise_error(Github::Error::NotFound)
      end
    end
  end # authorizations

  describe "#get" do
    let(:authorization_id) { 1 }

    context "resource found" do
      before do
        stub_get("/authorizations/#{authorization_id}", "https://#{basic_auth}@api.github.com").
          to_return(:body => fixture('auths/authorization.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without authorization id" do
        expect { github.oauth.get nil }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.oauth.get authorization_id
        a_get("/authorizations/#{authorization_id}", "https://#{basic_auth}@api.github.com").should have_been_made
      end

      it "should get authorization information" do
        authorization = github.oauth.get authorization_id
        authorization.id.should == authorization_id
        authorization.token.should == 'abc123'
      end

      it "should return mash" do
        authorization = github.oauth.get authorization_id
        authorization.should be_a Hashie::Mash
      end
    end

    context "resource not found" do
      before do
        stub_get("/authorizations/#{authorization_id}", "https://#{basic_auth}@api.github.com").
          to_return(:body => fixture('auths/authorization.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.oauth.get authorization_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # list

  describe "#create" do
    let(:inputs) { { :scopes => ['repo'] } }

    context "resouce created" do

      it "should fail to get resource without basic authentication" do
        reset_authentication_for github
        expect { github.oauth.create }.to raise_error(ArgumentError)
      end

      before do
        stub_post("/authorizations", "https://#{basic_auth}@api.github.com").with(inputs).
          to_return(:body => fixture('auths/authorization.json'), :status => 201, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should create resource successfully" do
        github.oauth.create inputs
        a_post("/authorizations", "https://#{basic_auth}@api.github.com").with(inputs).should have_been_made
      end

      it "should return the resource" do
        authorization = github.oauth.create inputs
        authorization.should be_a Hashie::Mash
      end

      it "should get the authorization information" do
        authorization = github.oauth.create inputs
        authorization.token.should == 'abc123'
      end
    end

    context "failed to create resource" do
      before do
        stub_post("/authorizations", "https://#{basic_auth}@api.github.com").with(inputs).
          to_return(:body => '', :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should fail to retrieve resource" do
        expect {
          github.oauth.create inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # create

  describe "#update" do
    let(:authorization_id) { 1 }
    let(:inputs) { { :add_scopes => ['repo'] } }

    context "resouce updated" do

      it "should fail to get resource without basic authentication" do
        reset_authentication_for github
        expect { github.oauth.update }.to raise_error(ArgumentError)
      end

      before do
        stub_patch("/authorizations/#{authorization_id}", "https://#{basic_auth}@api.github.com").with(inputs).
          to_return(:body => fixture('auths/authorization.json'), :status => 201, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should update resource successfully" do
        github.oauth.update authorization_id, inputs
        a_patch("/authorizations/#{authorization_id}", "https://#{basic_auth}@api.github.com").with(inputs).should have_been_made
      end

      it "should return the resource" do
        authorization = github.oauth.update authorization_id, inputs
        authorization.should be_a Hashie::Mash
      end

      it "should get the authorization information" do
        authorization = github.oauth.update authorization_id, inputs
        authorization.token.should == 'abc123'
      end
    end

    context "failed to update resource" do
      before do
        stub_patch("/authorizations/#{authorization_id}", "https://#{basic_auth}@api.github.com").with(inputs).
          to_return(:body => '', :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should fail to retrieve resource" do
        expect {
          github.oauth.update authorization_id, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # update

  describe "#delete" do
    let(:authorization_id) { 1 }
    let(:inputs) { { :add_scopes => ['repo'] } }

    context "resouce deleted" do

      it "should fail to get resource without basic authentication" do
        reset_authentication_for github
        expect { github.oauth.delete nil }.to raise_error(ArgumentError)
      end

      before do
        stub_delete("/authorizations/#{authorization_id}", "https://#{basic_auth}@api.github.com").
          to_return(:body => '', :status => 204, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should delete resource successfully" do
        github.oauth.delete authorization_id
        a_delete("/authorizations/#{authorization_id}", "https://#{basic_auth}@api.github.com").should have_been_made
      end
    end

    context "failed to create resource" do
      before do
        stub_delete("/authorizations/#{authorization_id}", "https://#{basic_auth}@api.github.com").
          to_return(:body => '', :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should fail to retrieve resource" do
        expect {
          github.oauth.delete authorization_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # delete

end # Github::Authorizations
