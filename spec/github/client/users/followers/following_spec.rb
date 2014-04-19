# encoding: utf-8

require 'spec_helper'

describe Github::Client::Users::Followers, '#following' do
  let(:user)   { 'peter-murach' }
  let(:request_path) { "/users/#{user}/following" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found for a user" do
    let(:body) { fixture('users/followers.json') }
    let(:status) { 200 }

    it "should get the resources" do
      subject.following user
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.following user }
    end

    it "should get following users information" do
      followings = subject.following user
      followings.first.login.should == 'octocat'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.following(user) { |obj| yielded << obj }
      yielded.should == result
    end
  end

  context "resource found for an authenticated user" do
    let(:body) { fixture('users/followers.json') }
    let(:status) { 200 }
    let(:request_path) { "/user/following" }

    before do
      subject.oauth_token = OAUTH_TOKEN
      stub_get(request_path).
        with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
        to_return(:body => fixture('users/followers.json'), :status => status,
          :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the resources" do
      subject.following
      a_get(request_path).with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
        should have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.following user }
  end

end # following
