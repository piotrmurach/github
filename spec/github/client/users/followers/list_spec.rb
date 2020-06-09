# encoding: utf-8

require 'spec_helper'

describe Github::Client::Users::Followers, '#list' do
  let(:user)   { 'peter-murach' }
  let(:request_path) { "/users/#{user}/followers" }

  before {
    subject.oauth_token = OAUTH_TOKEN
    stub_get(request_path).with(:query => { :access_token => OAUTH_TOKEN}).
      to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found for a user" do
    let(:status) { 200 }
    let(:body) { fixture('users/followers.json') }

    it { is_expected.to respond_to :all }

    it "should get the resources" do
      subject.list user
      expect(a_get(request_path).with(:query => { :access_token => OAUTH_TOKEN})).
        to have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list user }
    end

    it "should get followers information" do
      followers = subject.list user
      expect(followers.first.login).to eq 'octocat'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list(user) { |obj| yielded << obj }
      expect(yielded).to eq result
    end
  end

  context "resource found for an authenticated user" do
    let(:request_path) { "/user/followers" }
    let(:body) { fixture('users/followers.json') }
    let(:status) { 200 }

    it "should get the resources" do
      subject.list
      expect(a_get(request_path).with(:query => { :access_token => "#{OAUTH_TOKEN}"})).
        to have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.list user }
  end

end # list
