# encoding: utf-8

require 'spec_helper'

describe Github::Request::OAuth2 do
  include Github::Utils::Url

  def auth_header(env)
    env[:request_headers]['Authorization']
  end

  def middleware
    described_class.new(lambda { |env| env }, options)
  end

  def process(params={}, headers={})
    env = {
      :url => URI('http://example.com/?' + build_query(params)),
      :request_headers => headers
    }
    middleware.call(env)
  end

  context 'no token configured' do
    let(:options) { nil }

    it "doesn't add params" do
      result = process(:q => 'query')
      result[:url].query.should eql 'q=query'
    end

    it "doesn't add headers" do
      auth_header(process).should be_nil
    end

    it "allows for ad hoc access token" do
      result = process(:q => 'query', :access_token => 'abc123')
      result[:url].query.should eql 'access_token=abc123&q=query'
    end

    it "creates header for ad hoc access token" do
      result = process(:q => 'query', :access_token => 'abc123')
      auth_header(result).should eql 'token abc123'
    end
  end

  context 'default token configured' do
    let(:options) { 'ABC' }

    it "adds access token to params" do
      result = process(:q => 'query')
      result[:url].query.should eql 'access_token=ABC&q=query'
    end

    it "creates header for access token" do
      auth_header(process).should eql 'token ABC'
    end

    it "overrides default with explicit token" do
      result = process(:q => 'query', :access_token => 'abc123')
      result[:url].query.should eql 'access_token=abc123&q=query'
      auth_header(result).should eql 'token abc123'
    end

    it "clears default token with explicit one" do
      result = process(:q => 'query', :access_token => nil)
      result[:url].query.should eql 'q=query&access_token'
      auth_header(result).should be_nil
    end
  end

end # Github::Request::OAuth2
