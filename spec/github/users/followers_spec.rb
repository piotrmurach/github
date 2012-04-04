# encoding: utf-8

require 'spec_helper'

describe Github::Users::Followers do
  let(:github) { Github.new }
  let(:user)   { 'peter-murach' }

  after { reset_authentication_for github }

  describe "#list" do
    it { github.users.followers.should respond_to :all }

    context "resource found for a user" do
      before do
        stub_get("/users/#{user}/followers").
          to_return(:body => fixture('users/followers.json'),
            :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the resources" do
        github.users.followers.list user
        a_get("/users/#{user}/followers").should have_been_made
      end

      it "should return resource" do
        followers = github.users.followers.list user
        followers.should be_an Array
        followers.should have(1).items
      end

      it "should be a mash type" do
        followers = github.users.followers.list user
        followers.first.should be_a Hashie::Mash
      end

      it "should get followers information" do
        followers = github.users.followers.list user
        followers.first.login.should == 'octocat'
      end

      it "should yield to a block" do
        github.users.followers.should_receive(:list).with(user).and_yield('web')
        github.users.followers.list(user) { |param| 'web' }
      end
    end

    context "resource found for an authenticated user" do
      before do
        github.oauth_token = OAUTH_TOKEN
        stub_get("/user/followers").
          with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
          to_return(:body => fixture('users/followers.json'),
            :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the resources" do
        github.users.followers.list
        a_get("/user/followers").
          with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
          should have_been_made
      end
    end

    context "resource not found for a user" do
      before do
        stub_get("/users/#{user}/followers").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.users.followers.list user
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # list

  describe "#following" do
    context "resource found for a user" do
      before do
        stub_get("/users/#{user}/following").
          to_return(:body => fixture('users/followers.json'),
            :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the resources" do
        github.users.followers.following user
        a_get("/users/#{user}/following").should have_been_made
      end

      it "should return resource" do
        followings = github.users.followers.following user
        followings.should be_an Array
        followings.should have(1).items
      end

      it "should be a mash type" do
        followings = github.users.followers.following user
        followings.first.should be_a Hashie::Mash
      end

      it "should get following users information" do
        followings = github.users.followers.following user
        followings.first.login.should == 'octocat'
      end

      it "should yield to a block" do
        github.users.followers.should_receive(:following).with(user).and_yield('web')
        github.users.followers.following(user) { |param| 'web' }
      end
    end

    context "resource found for an authenticated user" do
      before do
        github.oauth_token = OAUTH_TOKEN
        stub_get("/user/following").
          with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
          to_return(:body => fixture('users/followers.json'),
            :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the resources" do
        github.users.followers.following
        a_get("/user/following").
          with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
          should have_been_made
      end
    end

    context "resource not found for a user" do
      before do
        stub_get("/users/#{user}/following").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.users.followers.following user
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # following

  context '#following?' do
    before do
      github.oauth_token = OAUTH_TOKEN
      stub_get("/user/following/#{user}").
        with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
        to_return(:body => '',
              :status => 204,
              :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it 'should raise error if username not present' do
      expect {
        github.users.followers.following? nil
      }.to raise_error(ArgumentError)
    end

    it 'should perform request' do
      github.users.followers.following?(user)
      a_get("/user/following/#{user}").
        with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
        should have_been_made
    end

    it 'should return true if user is being followed' do
      github.users.followers.following?(user).should be_true
    end

    it 'should return false if user is not being followed' do
      stub_get("/user/following/#{user}").
        with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
        to_return(:body => '',
              :status => 404,
              :headers => {:content_type => "application/json; charset=utf-8"})
      github.users.followers.following?(user).should be_false
    end
  end # following?

  context '#follow' do
    before do
      github.oauth_token = OAUTH_TOKEN
      stub_put("/user/following/#{user}").
        with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
        to_return(:body => '',
              :status => 204,
              :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should raise error if gist id not present" do
      expect {
        github.users.followers.follow nil
      }.to raise_error(ArgumentError)
    end

    it 'successfully unfollows a user' do
      github.users.followers.follow(user)
      a_put("/user/following/#{user}").
        with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
        should have_been_made
    end

    it "should return 204 with a message 'Not Found'" do
      github.users.followers.follow(user).status.should be 204
    end
  end # follow

  context '#unfollow' do
    before do
      github.oauth_token = OAUTH_TOKEN
      stub_delete("/user/following/#{user}").
        with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
        to_return(:body => '',
              :status => 204,
              :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should raise error if gist id not present" do
      expect {
        github.users.followers.unfollow nil
      }.to raise_error(ArgumentError)
    end

    it 'successfully unfollows a user' do
      github.users.followers.unfollow(user)
      a_delete("/user/following/#{user}").
        with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
        should have_been_made
    end

    it "should return 204 with a message 'Not Found'" do
      github.users.followers.unfollow(user).status.should be 204
    end
  end # unfollow

end # Github::Users::Followers
