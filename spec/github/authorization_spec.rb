# encoding: utf-8

require 'spec_helper'

describe Github::Authorization do
  let(:client_id) { '234jl23j4l23j4l' }
  let(:client_secret) { 'asasd79sdf9a7asfd7sfd97s' }
  let(:code) { 'c9798sdf97df98ds'}
  let(:site) { 'http://github-ent.example.com/' }
  let(:options) { {:site => site} }

  subject(:github) { Github.new(options) }

  after do
    reset_authentication_for(github)
  end

  context '.client' do
    it { is_expected.to respond_to :client }

    it "should return OAuth2::Client instance" do
      expect(github.client).to be_a OAuth2::Client
    end

    it "should assign site from the options hash" do
      expect(github.client.site).to eq site
    end

    it "should assign 'authorize_url" do
      expect(github.client.authorize_url).to eq "#{site}login/oauth/authorize"
    end

    it "should assign 'token_url" do
      expect(github.client.token_url).to eq "#{site}login/oauth/access_token"
    end
  end

  context '.auth_code' do
    let(:oauth) { OAuth2::Client.new(client_id, client_secret) }

    it "should throw an error if no client_id" do
      expect { github.auth_code }.to raise_error(ArgumentError)
    end

    it "should throw an error if no client_secret" do
      expect { github.auth_code }.to raise_error(ArgumentError)
    end

    it "should return authentication token code" do
      github.client_id = client_id
      github.client_secret = client_secret
      allow(github.client).to receive(:auth_code).and_return code
      expect(github.auth_code).to eq code
    end
  end

  context "authorize_url" do
    let(:options) { {:client_id => client_id, :client_secret => client_secret} }

    it { is_expected.to respond_to(:authorize_url) }

    it "should return address containing client_id" do
      expect(github.authorize_url).to match /client_id=#{client_id}/
    end

    it "should return address containing scopes" do
      expect(github.authorize_url(:scope => 'user')).to match /scope=user/
    end

    it "should return address containing redirect_uri" do
      expect(github.authorize_url(:redirect_uri => 'http://localhost')).to match /redirect_uri/
    end
  end

  context "get_token" do
    let(:options) { {:client_id => client_id, :client_secret => client_secret} }

    before do
      stub_request(:post, 'https://github.com/login/oauth/access_token').
        to_return(:body => '', :status => 200, :headers => {})
    end

    it { is_expected.to respond_to(:get_token) }

    it "should make the authorization request" do
      expect {
        github.get_token code
        a_request(:post, expect("https://github.com/login/oauth/access_token")).to have_been_made
      }.to raise_error(OAuth2::Error)
    end

    it "should fail to get_token without authorization code" do
      expect { github.get_token }.to raise_error(ArgumentError)
    end
  end

  context ".authenticated?" do
    it { is_expected.to respond_to(:authenticated?) }

    it "should return false if falied on basic authentication" do
      allow(github).to receive(:basic_authed?).and_return false
      expect(github.authenticated?).to be false
    end

    it "should return true if basic authentication performed" do
      allow(github).to receive(:basic_authed?).and_return true
      expect(github.authenticated?).to be true
    end

    it "should return true if basic authentication performed" do
      allow(github).to receive(:oauth_token?).and_return true
      expect(github.authenticated?).to be true
    end
  end

  context ".basic_authed?" do
    before do
      allow(github).to receive(:basic_auth?).and_return false
    end

    it { is_expected.to respond_to(:basic_authed?) }

    it "should return false if login is missing" do
      allow(github).to receive(:login?).and_return false
      expect(github.basic_authed?).to be false
    end

    it "should return true if login && password provided" do
      allow(github).to receive(:login?).and_return true
      allow(github).to receive(:password?).and_return true
      expect(github.basic_authed?).to be true
    end
  end

  context "authentication" do
    it { is_expected.to respond_to(:authentication) }

    it "should return empty hash if no basic authentication params available" do
      allow(github).to receive(:login?).and_return false
      allow(github).to receive(:basic_auth?).and_return false
      expect(github.authentication).to be_empty
    end

    context 'basic_auth' do
      let(:options) { { :basic_auth => 'github:pass' } }

      it "should return hash with basic auth params" do
        expect(github.authentication).to include({login: 'github'})
        expect(github.authentication).to include({password: 'pass'})
      end
    end

    context 'login & password' do
      it "should return hash with login & password params" do
        options = {login: 'github', password: 'pass'}
        github = Github.new(options)

        expect(github.authentication).to be_a(Hash)
        expect(github.authentication).to include({login: 'github'})
        expect(github.authentication).to include({password: 'pass'})

        reset_authentication_for(github)
      end
    end
  end # authentication
end # Github::Authorization
