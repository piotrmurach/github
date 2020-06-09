# encoding: utf-8

require 'spec_helper'

describe Github::Client::Users, '#get' do
  let(:user) { 'peter-murach' }
  let(:request_path) { "/users/#{user}" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found for a user" do
    let(:body)   { fixture('users/user.json') }
    let(:status) { 200 }

    it { is_expected.to respond_to :find }

    it "should get the resources" do
      subject.get :user => user
      expect(a_get(request_path)).to have_been_made
    end

    it "is_expected.to be a response wrapper" do
      user_resource = subject.get :user => user
      expect(user_resource).to be_a Github::ResponseWrapper
    end

    it "should get org information" do
      user_resource = subject.get :user => user
      expect(user_resource.login).to eq 'octocat'
    end
  end

  context "resource found for an authenticated user" do
    let(:request_path) { "/user" }
    let(:body) { fixture('users/user.json') }
    let(:status) { 200 }

    before do
      subject.oauth_token = OAUTH_TOKEN
      stub_get(request_path).with(:query => { :access_token => OAUTH_TOKEN}).
        to_return(:body => fixture('users/user.json'), :status => 200,
        :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the resources" do
      subject.get
      expect(a_get(request_path).with(:query => {:access_token => OAUTH_TOKEN})).
        to have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get :user => user }
  end

end # get
