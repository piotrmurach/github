require 'spec_helper'

describe Github::Authorization do

  let(:client_id) { '234jl23j4l23j4l' }
  let(:client_secret) { 'asasd79sdf9a7asfd7sfd97s' }
  let(:code) { 'c9798sdf97df98ds'}
  let(:github) { Github.new }

  it "should instantiate oauth2 instance" do
    github.client.should be_a OAuth2::Client
  end

  it "should assign site from the options hash" do
    github.client.site.should == 'https://github.com'
  end

  it "should assign 'authorize_url" do
    github.client.authorize_url.should == 'https://github.com/login/oauth/authorize'
  end

  it "should assign 'token_url" do
    github.client.token_url.should == 'https://github.com/login/oauth/access_token'
  end

  context "authorize_url" do
    before do
      github = Github.new :client_id => client_id, :client_secret => client_secret
    end

    it "should respond to 'authorize_url' " do
      github.should respond_to :authorize_url
    end

    it "should return address containing client_id" do
      github.authorize_url.should =~ /client_id=#{client_id}/
    end

    it "should return address containing scopes" do
      github.authorize_url(:scope => 'user').should =~ /scope=user/
    end

    it "should return address containing redirect_uri" do
      github.authorize_url(:redirect_uri => 'http://localhost').should =~ /redirect_uri/
    end
  end

  context "get_token" do
    before do
      github = Github.new :client_id => client_id, :client_secret => client_secret
      stub_request(:post, 'https://github.com/login/oauth/access_token').
        to_return(:body => '', :status => 200, :headers => {})
    end

    it "should respond to 'get_token' " do
      github.should respond_to :get_token
    end

    it "should make the authorization request" do
      expect {
        github.get_token code
        a_request(:post, "https://github.com/login/oauth/access_token").should have_been_made
      }.to raise_error(OAuth2::Error)
    end

    it "should fail to get_token without authorization code" do
      expect { github.get_token }.to raise_error(ArgumentError)
    end
  end

  context "authentication" do
    it "should respond to 'authentication'" do
      github.should respond_to :authentication
    end

    context 'basic_auth' do
      before do
        github = Github.new :basic_auth => 'github:pass'
      end

      it "should return hash with basic auth params" do
        github.authentication.should be_a Hash
        github.authentication.should have_key :basic_auth
      end
    end

    context 'login & password' do
      before do
        github = Github.new :login => 'github', :password => 'pass'
      end

      it "should return hash with login & password params" do
        github.authentication.should be_a Hash
        github.authentication.should have_key :login
      end
    end
  end # authentication

end # Github::Authorization
