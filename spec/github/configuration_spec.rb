# encoding: utf-8

require 'spec_helper'

describe Github::Configuration do
  let(:klass) {
    ::Class.new do
      extend Github::Configuration
    end
  }

  subject { klass }

  its(:adapter) { should == described_class::DEFAULT_ADAPTER }

  its(:endpoint) { should == described_class::DEFAULT_ENDPOINT }

  its(:site) { should == described_class::DEFAULT_SITE }

  its(:user_agent) { should == described_class::DEFAULT_USER_AGENT }

  its(:oauth_token) { should be_nil }

  its(:auto_pagination) { should == described_class::DEFAULT_AUTO_PAGINATION }

  its(:auto_pagination) { should be_false }

  its(:ssl) { should == described_class::DEFAULT_SSL }

  its(:ssl) { should be_a Hash }

  its(:user_agent) { should == described_class::DEFAULT_USER_AGENT }

  its(:repo) { should be_nil }

  its(:user) { should be_nil }

  its(:org)  { should be_nil }

  its(:connection_options) { should be_a Hash }

  its(:connection_options) { should be_empty }

  its(:login) { should == described_class::DEFAULT_LOGIN }

  its(:password) { should == described_class::DEFAULT_PASSWORD }

  describe ".configure" do
    it { should respond_to :configure }

    described_class.keys.each do |key|
      it "should set the #{key}" do
        subject.configure do |config|
          config.send("#{key}=", key)
          subject.send(key).should == key
        end
      end
    end
  end

end
