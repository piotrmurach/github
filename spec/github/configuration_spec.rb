# encoding: utf-8

require 'spec_helper'

describe Github::Configuration do

  let(:instance) { described_class.new }

  subject { instance }

  its(:adapter) { should == :net_http }

  its(:endpoint) { should == 'https://api.github.com' }

  its(:site) { should == 'https://github.com' }

  its(:user_agent) { should =~ /Github API Ruby Gem/ }

  its(:oauth_token) { should be_nil }

  its(:auto_pagination) { should be_false }

  its(:ssl) { should_not be_empty }

  its(:ssl) { should be_a Hash }

  its(:repo) { should be_nil }

  its(:user) { should be_nil }

  its(:org)  { should be_nil }

  its(:connection_options) { should be_a Hash }

  its(:connection_options) { should be_empty }

  its(:login) { should be_nil }

  its(:password) { should be_nil }

  its(:basic_auth) { should be_nil }

  describe ".call" do
    before { subject.adapter = :net_http }

    after { subject.adapter = :net_http }

    it { should respond_to :call }

    it "evaluates block" do
      block = Proc.new { |config| config.adapter= :http }
      subject.call(&block)
      expect(subject.adapter).to eql(:http)
    end
  end
end
