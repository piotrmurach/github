# encoding: utf-8

require 'spec_helper'

describe Github::Client::Activity::Watching, '#watched' do
  let(:user) { 'peter-murach' }

  after { reset_authentication_for subject }

  context "if user unauthenticated" do
    it "should fail to get resource without username " do
      stub_get("/user/subscriptions").
        to_return(:body => '', :status => 401, :headers => {})
      expect {
        subject.watched
      }.to raise_error(Github::Error::Unauthorized)
    end

    it "should get the resource with username" do
      stub_get("/users/#{user}/subscriptions").
        to_return(:body => fixture("repos/watched.json"), :status => 200, :headers => {})
      subject.watched :user => user
      a_get("/users/#{user}/subscriptions").should have_been_made
    end
  end

  context "if user authenticated" do
    before do
      subject.oauth_token = OAUTH_TOKEN
      stub_get("/user/subscriptions").
        with(:query => {:access_token => OAUTH_TOKEN}).
        to_return(:body => fixture("repos/watched.json"), :status => 200, :headers => {})
    end

    it "should get the resources" do
      subject.watched
      a_get("/user/subscriptions").with(:query => {:access_token => OAUTH_TOKEN}).
        should have_been_made
    end

    it "should return array of resources" do
      watched = subject.watched
      watched.should be_an Enumerable
      watched.should have(1).items
    end

    it "should get watched information" do
      watched = subject.watched
      watched.first.name.should == 'Hello-World'
    end
  end
end # watched

