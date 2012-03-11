# encoding: utf-8

require 'spec_helper'

describe Github::Users::Followers do
  let(:github) { Github.new }
  let(:user)   { 'peter-murach' }

  after { reset_authentication_for github }

  describe "#followers" do
    context "resource found for a user" do
      before do
        stub_get("/users/#{user}/followers").
          to_return(:body => fixture('users/followers.json'),
            :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the resources" do
        github.users.followers user
        a_get("/users/#{user}/followers").should have_been_made
      end

      it "should return resource" do
        followers = github.users.followers user
        followers.should be_an Array
        followers.should have(1).items
      end

      it "should be a mash type" do
        followers = github.users.followers user
        followers.first.should be_a Hashie::Mash
      end

      it "should get followers information" do
        followers = github.users.followers user
        followers.first.login.should == 'octocat'
      end

      it "should yield to a block" do
        github.users.should_receive(:followers).with(user).and_yield('web')
        github.users.followers(user) { |param| 'web' }
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
        github.users.followers
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
          github.users.followers user
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # followers

  describe "#following" do
    context "resource found for a user" do
      before do
        stub_get("/users/#{user}/following").
          to_return(:body => fixture('users/followers.json'),
            :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the resources" do
        github.users.following user
        a_get("/users/#{user}/following").should have_been_made
      end

      it "should return resource" do
        followings = github.users.following user
        followings.should be_an Array
        followings.should have(1).items
      end

      it "should be a mash type" do
        followings = github.users.following user
        followings.first.should be_a Hashie::Mash
      end

      it "should get following users information" do
        followings = github.users.following user
        followings.first.login.should == 'octocat'
      end

      it "should yield to a block" do
        github.users.should_receive(:following).with(user).and_yield('web')
        github.users.following(user) { |param| 'web' }
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
        github.users.following
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
          github.users.following user
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
        github.users.following? nil
      }.to raise_error(ArgumentError)
    end

    it 'should perform request' do
      github.users.following?(user)
      a_get("/user/following/#{user}").
        with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
        should have_been_made
    end

    it 'should return true if user is being followed' do
      github.users.following?(user).should be_true
    end

    it 'should return false if user is not being followed' do
      stub_get("/user/following/#{user}").
        with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
        to_return(:body => '',
              :status => 404,
              :headers => {:content_type => "application/json; charset=utf-8"})
      github.users.following?(user).should be_false
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
        github.users.follow nil
      }.to raise_error(ArgumentError)
    end

    it 'successfully unfollows a user' do
      github.users.follow(user)
      a_put("/user/following/#{user}").
        with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
        should have_been_made
    end

    it "should return 204 with a message 'Not Found'" do
      github.users.follow(user).status.should be 204
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
        github.users.unfollow nil
      }.to raise_error(ArgumentError)
    end

    it 'successfully unfollows a user' do
      github.users.unfollow(user)
      a_delete("/user/following/#{user}").
        with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
        should have_been_made
    end

    it "should return 204 with a message 'Not Found'" do
      github.users.unfollow(user).status.should be 204
    end
  end # unfollow

end # Github::Users::Followers
