require 'spec_helper'

describe Github::Users::Keys do
  let(:github) { Github.new }
  let(:key_id) { 1 }

  before { github.oauth_token = OAUTH_TOKEN }
  after { reset_authentication_for github }

  describe "#keys" do
    context "resource found for an authenticated user" do
      before do
        stub_get("/user/keys").
          with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
          to_return(:body => fixture('users/keys.json'),
            :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the resources" do
        github.users.keys
        a_get("/user/keys").
          with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
          should have_been_made
      end

      it "should return resource" do
        keys = github.users.keys
        keys.should be_an Array
        keys.should have(1).item
      end

      it "should get keys information" do
        keys = github.users.keys
        keys.first.id.should == key_id
      end

      it "should yield to a block" do
        github.users.should_receive(:keys).and_yield('web')
        github.users.keys { |param| 'web' }
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
          github.users.keys
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # keys

  describe "#key" do
    context "resource found for an authenticated user" do
      before do
        stub_get("/user/keys/#{key_id}").
          with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
          to_return(:body => fixture('users/key.json'),
            :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without key id" do
        expect { github.users.key nil }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.users.key key_id
        a_get("/user/keys/#{key_id}").
          with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
          should have_been_made
      end

      it "should get public key information" do
        key = github.users.key key_id
        key.id.should == key_id
        key.title.should == 'octocat@octomac'
      end

      it "should return mash" do
        key = github.users.key key_id
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
          github.users.key key_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # key

  describe "create_key" do
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
          with(:body => JSON.generate(inputs.except(:unrelated))).
          to_return(:body => fixture('users/key.json'),
            :status => 201,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should create resource successfully" do
        github.users.create_key inputs
        a_post("/user/keys?access_token=#{OAUTH_TOKEN}").
          with(inputs).should have_been_made
      end

      it "should return the resource" do
        key = github.users.create_key inputs
        key.should be_a Hashie::Mash
      end

      it "should get the key information" do
        key = github.users.create_key inputs
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
          github.users.create_key inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # create_key

  describe "#update_key" do
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
          with(:body => JSON.generate(inputs.except(:unrelated))).
          to_return(:body => fixture('users/key.json'),
            :status => 201,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without key id" do
        expect { github.users.update_key nil }.to raise_error(ArgumentError)
      end

      it "should create resource successfully" do
        github.users.update_key key_id, inputs
        a_patch("/user/keys/#{key_id}?access_token=#{OAUTH_TOKEN}").
          with(inputs).should have_been_made
      end

      it "should return the resource" do
        key = github.users.update_key key_id, inputs
        key.should be_a Hashie::Mash
      end

      it "should get the key information" do
        key = github.users.update_key key_id, inputs
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
          github.users.update_key key_id, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # update_key

  describe "#delete_key" do
    context "resouce deleted" do
      before do
        stub_delete("/user/keys/#{key_id}?access_token=#{OAUTH_TOKEN}").
          to_return(:body => fixture('users/key.json'),
            :status => 204,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without key id" do
        expect { github.users.delete_key nil }.to raise_error(ArgumentError)
      end

      it "should create resource successfully" do
        github.users.delete_key key_id
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
          github.users.delete_key key_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # delete_key

end # Github::Users::Keys
