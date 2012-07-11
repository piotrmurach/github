require 'spec_helper'

describe Github::Users::Keys do
  let(:github) { Github.new }
  let(:key_id) { 1 }

  before { github.oauth_token = OAUTH_TOKEN }
  after { reset_authentication_for github }

  describe "#list" do
    it { github.users.keys.should respond_to :all }

    context "resource found for an authenticated user" do
      before do
        stub_get("/user/keys").
          with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
          to_return(:body => fixture('users/keys.json'),
            :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the resources" do
        github.users.keys.list
        a_get("/user/keys").
          with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
          should have_been_made
      end

      it "should return resource" do
        keys = github.users.keys.list
        keys.should be_an Array
        keys.should have(1).item
      end

      it "should get keys information" do
        keys = github.users.keys.list
        keys.first.id.should == key_id
      end

      it "should yield to a block" do
        github.users.keys.should_receive(:list).and_yield('web')
        github.users.keys.list { |param| 'web' }
      end
    end

    context "resource not found for a user" do
      before do
        stub_get("/user/keys").
          with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.users.keys.list
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # list

  describe "#get" do
    it { github.users.keys.should respond_to :find }

    context "resource found for an authenticated user" do
      before do
        stub_get("/user/keys/#{key_id}").
          with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
          to_return(:body => fixture('users/key.json'),
            :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without key id" do
        expect { github.users.keys.get nil }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.users.keys.get key_id
        a_get("/user/keys/#{key_id}").
          with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
          should have_been_made
      end

      it "should get public key information" do
        key = github.users.keys.get key_id
        key.id.should == key_id
        key.title.should == 'octocat@octomac'
      end

      it "should return mash" do
        key = github.users.keys.get key_id
        key.should be_a Hashie::Mash
      end
    end

    context "resource not found" do
      before do
        stub_get("/user/keys/#{key_id}").
          with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
          to_return(:body => fixture('users/key.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.users.keys.get key_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # get

  describe "#create" do
    let(:inputs) {
      {
        :title => "octocat@octomac",
        :key => "ssh-rsa AAA...",
        :unrelated => true
      }
    }

    context "resouce created" do
      before do
        stub_post("/user/keys?access_token=#{OAUTH_TOKEN}").
          with(inputs.except(:unrelated)).
          to_return(:body => fixture('users/key.json'),
            :status => 201,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should create resource successfully" do
        github.users.keys.create inputs
        a_post("/user/keys?access_token=#{OAUTH_TOKEN}").
          with(inputs).should have_been_made
      end

      it "should return the resource" do
        key = github.users.keys.create inputs
        key.should be_a Hashie::Mash
      end

      it "should get the key information" do
        key = github.users.keys.create inputs
        key.title.should == 'octocat@octomac'
      end
    end

    context "fail to create resource" do
      before do
        stub_post("/user/keys?access_token=#{OAUTH_TOKEN}").with(inputs).
          to_return(:body => fixture('users/key.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrieve resource" do
        expect {
          github.users.keys.create inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # create

  describe "#update" do
    let(:inputs) {
      {
        :title => "octocat@octomac",
        :key => "ssh-rsa AAA...",
        :unrelated => true
      }
    }

    context "resouce updated" do
      before do
        stub_patch("/user/keys/#{key_id}?access_token=#{OAUTH_TOKEN}").
          with(inputs.except(:unrelated)).
          to_return(:body => fixture('users/key.json'),
            :status => 201,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without key id" do
        expect { github.users.keys.update nil }.to raise_error(ArgumentError)
      end

      it "should create resource successfully" do
        github.users.keys.update key_id, inputs
        a_patch("/user/keys/#{key_id}?access_token=#{OAUTH_TOKEN}").
          with(inputs).should have_been_made
      end

      it "should return the resource" do
        key = github.users.keys.update key_id, inputs
        key.should be_a Hashie::Mash
      end

      it "should get the key information" do
        key = github.users.keys.update key_id, inputs
        key.title.should == 'octocat@octomac'
      end
    end

    context "fail to update resource" do
      before do
        stub_patch("/user/keys/#{key_id}?access_token=#{OAUTH_TOKEN}").
          with(inputs).
          to_return(:body => fixture('users/key.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrieve resource" do
        expect {
          github.users.keys.update key_id, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # update

  describe "#delete" do
    context "resouce deleted" do
      before do
        stub_delete("/user/keys/#{key_id}?access_token=#{OAUTH_TOKEN}").
          to_return(:body => fixture('users/key.json'),
            :status => 204,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without key id" do
        expect { github.users.keys.delete nil }.to raise_error(ArgumentError)
      end

      it "should create resource successfully" do
        github.users.keys.delete key_id
        a_delete("/user/keys/#{key_id}?access_token=#{OAUTH_TOKEN}").
          should have_been_made
      end
    end

    context "fail to delete resource" do
      before do
        stub_delete("/user/keys/#{key_id}?access_token=#{OAUTH_TOKEN}").
          to_return(:body => fixture('users/key.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to delete resource" do
        expect {
          github.users.keys.delete key_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # delete

end # Github::Users::Keys
