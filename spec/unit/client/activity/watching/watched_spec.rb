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
      expect(a_get("/users/#{user}/subscriptions")).to have_been_made
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
      expect(a_get("/user/subscriptions").with(:query => {:access_token => OAUTH_TOKEN})).
        to have_been_made
    end

    it "should return array of resources" do
      watched = subject.watched
      expect(watched).to be_an Enumerable
      expect(watched.size).to eq(1)
    end

    it "should get watched information" do
      watched = subject.watched
      expect(watched.first.name).to eq('Hello-World')
    end
  end
end # watched

