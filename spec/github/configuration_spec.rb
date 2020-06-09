# encoding: utf-8

require 'spec_helper'

describe Github::Configuration do

  let(:instance) { described_class.new }

  subject { instance }

  its(:adapter) { is_expected.to eq :net_http }

  its(:endpoint) { is_expected.to eq 'https://api.github.com' }

  its(:site) { is_expected.to eq 'https://github.com' }

  its(:upload_endpoint) { is_expected.to eq 'https://uploads.github.com' }

  its(:user_agent) { is_expected.to match /Github API Ruby Gem/ }

  its(:oauth_token) { is_expected.to be_nil }

  its(:auto_pagination) { is_expected.to be false }

  its(:ssl) { is_expected.to_not be_empty }

  its(:ssl) { is_expected.to be_a Hash }

  its(:repo) { is_expected.to be_nil }

  its(:user) { is_expected.to be_nil }

  its(:org)  { is_expected.to be_nil }

  its(:connection_options) { is_expected.to be_a Hash }

  its(:connection_options) { is_expected.to be_empty }

  its(:login) { is_expected.to be_nil }

  its(:password) { is_expected.to be_nil }

  its(:basic_auth) { is_expected.to be_nil }

  describe ".call" do
    before { subject.adapter = :net_http }

    after { subject.adapter = :net_http }

    it { is_expected.to respond_to :call }

    it "evaluates block" do
      block = Proc.new { |config| config.adapter= :http }
      subject.call(&block)
      expect(subject.adapter).to eql(:http)
    end
  end
end
