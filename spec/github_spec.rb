# encoding: utf-8

require 'spec_helper'

describe Github do

  after do
    subject.set_defaults
    reset_authentication_for subject
  end

  it "should respond to 'new' message" do
    subject.should respond_to :new
  end

  it "should receive 'new' and initialize subject::Client instance" do
    subject.new.should be_a Github::Client
  end

  it "should respond to 'configure' message" do
    subject.should respond_to :configure
  end

  describe "setting configuration options" do
    it "should return default adapter" do
      subject.adapter.should == Github::Configuration::DEFAULT_ADAPTER
    end

    it "should allow to set adapter" do
      subject.adapter = :typhoeus
      subject.adapter.should == :typhoeus
    end

    it "should return the default end point" do
      subject.endpoint.should == Github::Configuration::DEFAULT_ENDPOINT
    end

    it "should allow to set endpoint" do
      subject.endpoint = 'http://linkedin.com'
      subject.endpoint.should == 'http://linkedin.com'
    end

    it "should return the default user agent" do
      subject.user_agent.should == Github::Configuration::DEFAULT_USER_AGENT
    end

    it "should allow to set new user agent" do
      subject.user_agent = 'New User Agent'
      subject.user_agent.should == 'New User Agent'
    end

    it "should have not set oauth token" do
      subject.oauth_token.should be_nil
    end

    it "should allow to set oauth token" do
      subject.oauth_token = ''
    end

    it "should have not set default user" do
      subject.user.should be_nil
    end

    it "should allow to set new user" do
      subject.user = 'github'
      subject.user.should == 'github'
    end

    it "should have not set default repository" do
      subject.repo.should be_nil
    end

    it "should allow to set new repository" do
      subject.repo = 'github'
      subject.repo.should == 'github'
    end

    it "should have connection options as hash" do
      subject.connection_options.should be_a Hash
    end

    it "should initialize connection options to empty hash" do
      subject.connection_options.should be_empty
    end

    it "shoulve have not set user's login" do
      subject.login.should be_nil
    end

    it "should have not set user's password" do
      subject.password.should be_nil
    end

    it "should have set mime type to json" do
      subject.mime_type.should == :json
    end

    it "should allow to set current api client" do
      subject.should respond_to :api_client=
      subject.should respond_to :api_client
    end
  end

  describe ".configure" do
    Github::Configuration::VALID_OPTIONS_KEYS.each do |key|
      it "should set the #{key}" do
        Github.configure do |config|
          config.send("#{key}=", key)
          Github.send(key).should == key
        end
      end
    end
  end

end # Github
