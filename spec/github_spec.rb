require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Github do

  it "should respond to 'new' message" do
    Github.should respond_to :new
  end

  it "should receive 'new' and initialize Github::Client instance" do
    Github.new.should be_a Github::Client
  end

  it "should respond to 'configure' message" do
    Github.should respond_to :configure
  end

  describe "setting configuration options" do

    it "should return default adapter" do
      Github.adapter.should == Github::Configuration::DEFAULT_ADAPTER
    end

    it "should allow to set adapter" do
      Github.adapter = :typhoeus
      Github.adapter.should == :typhoeus
    end

    it "should return the default end point" do
      Github.endpoint.should == Github::Configuration::DEFAULT_ENDPOINT
    end

    it "should allow to set endpoint" do
      Github.endpoint = 'http://linkedin.com'
      Github.endpoint.should == 'http://linkedin.com'
    end

    it "should return the default user agent" do
      Github.user_agent.should == Github::Configuration::DEFAULT_USER_AGENT
    end

    it "should allow to set new user agent" do
      Github.user_agent = 'New User Agent'
      Github.user_agent.should == 'New User Agent'
    end

    it "should have not set oauth token" do
      Github.oauth_token.should be_nil
    end

    it "should allow to set oauth token" do
      Github.oauth_token = ''
    end

    it "should have not set default user" do
      Github.user.should be_nil
    end

    it "should allow to set new user" do
      Github.user = 'github'
      Github.user.should == 'github'
    end

    it "should have not set default repository" do
      Github.repo.should be_nil
    end

    it "should allow to set new repository" do
      Github.repo = 'github'
      Github.repo.should == 'github'
    end

    it "should have faraday options as hash" do
      Github.faraday_options.should be_a Hash
    end

    it "should initialize faraday options to empty hash" do
      Github.faraday_options.should be_empty
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

end
