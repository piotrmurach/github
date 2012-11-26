# encoding: utf-8

require 'spec_helper'

describe Github::Users, '#get' do
  let(:user) { 'peter-murach' }
  let(:request_path) { "/users/#{user}" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  context "resource found for a user" do
    let(:body) { fixture('users/user.json') }
    let(:status) { 200 }

    it { should respond_to :find }

    it "should get the resources" do
      subject.get :user => user
      a_get(request_path).should have_been_made
    end

    it "should return resource" do
      user_resource = subject.get :user => user
      user_resource.should be_a Hash
    end

    it "should be a mash type" do
      user_resource = subject.get :user => user
      user_resource.should be_a Hashie::Mash
    end

    it "should get org information" do
      user_resource = subject.get :user => user
      user_resource.login.should == 'octocat'
    end
  end

  context "resource found for an authenticated user" do
    let(:body) { nil}
    let(:status) { nil }

    before do
      subject.oauth_token = OAUTH_TOKEN
      stub_get("/user").with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
        to_return(:body => fixture('users/user.json'), :status => 200,
        :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the resources" do
      subject.get
      a_get("/user").with(:query => {:access_token => "#{OAUTH_TOKEN}"}).
        should have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get :user => user }
  end

end # get
