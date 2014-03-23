# encoding: utf-8

require 'spec_helper'

describe Github::Client::Activity::Starring, '#starred' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }

  after { reset_authentication_for subject }

  context "if user unauthenticated" do
    it "should fail to get resource without username " do
      stub_get("/user/starred").
        to_return(:body => '', :status => 401, :headers => {})
      expect { subject.starred }.to raise_error(Github::Error::Unauthorized)
    end

    it "should get the resource with username" do
      stub_get("/users/#{user}/starred").
        to_return(:body => fixture("repos/starred.json"), :status => 200, :headers => {})
      subject.starred :user => user
      a_get("/users/#{user}/starred").should have_been_made
    end
  end

  context "if user authenticated" do
    before do
      subject.oauth_token = OAUTH_TOKEN
      stub_get("/user/starred").
        with(:query => {:access_token => OAUTH_TOKEN}).
        to_return(:body => fixture("repos/starred.json"),
          :status => 200, :headers => {})
    end

    it "should get the resources" do
      subject.starred
      a_get("/user/starred").with(:query => {:access_token => OAUTH_TOKEN}).
        should have_been_made
    end

    it "should return array of resources" do
      starred = subject.starred
      starred.should be_an Enumerable
      starred.should have(1).items
    end

    it "should get starred information" do
      starred = subject.starred
      starred.first.name.should == 'Hello-World'
      starred.first.owner.login.should == 'octocat'
    end
  end
end # starred
