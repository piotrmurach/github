# encoding: utf-8

require 'spec_helper'

describe Github::Request do
  let(:github)   { Github::API.new  }
  let(:path)     { 'github.api/repos/users' }
  let(:params)   { {} }
  let(:request)  { double('request') }
  let(:response) { double('response').as_null_object }

  it "knows how to make get request" do
    expect(Github::Request).to receive(:new).with(:get, path, github) { request }
    expect(request).to receive(:call).with(github.current_options, params) { double(auto_paginate: true) }
    github.get_request path, params
  end

  it "knows how to make patch request" do
    expect(Github::Request).to receive(:new).with(:patch, path, github) { request }
    expect(request).to receive(:call).with(github.current_options, params)
    github.patch_request path, params
  end

  it "knows how to make post request" do
    expect(Github::Request).to receive(:new).with(:post, path, github) { request }
    expect(request).to receive(:call).with(github.current_options, params)
    github.post_request path, params
  end

  it "knows how to make put request" do
    expect(Github::Request).to receive(:new).with(:put, path, github) { request }
    expect(request).to receive(:call).with(github.current_options, params)
    github.put_request path, params
  end

  it "knows how to make delete request" do
    expect(Github::Request).to receive(:new).with(:delete, path, github) { request }
    expect(request).to receive(:call).with(github.current_options, params)
    github.delete_request path, params
  end

  context "with invalid characters in path" do
    let(:wrong_path)     { 'github.api/$repos★/!usersÇ' }
    let(:normalized_url) { 'https://api.github.com/github.api/$repos%E2%98%85/!users%C3%87' }
    let(:headers) do
    {
      :headers => {
        'Accept'          => 'application/vnd.github.v3+json,application/vnd.github.beta+json;q=0.5,application/json;q=0.1',
        'Accept-Charset'  => 'utf-8',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'      => 'Github API Ruby Gem 0.12.3'}
    }
    end

    before do
      expect(params).to receive(:options).exactly(5).times        { { raw: false } }
      expect(params).to receive(:request_params).exactly(2).times { {} }
    end

    it "removes invalid characters before making a request" do
      [:get, :patch, :post, :put, :delete].each do |request_type|
        stub_request(request_type, normalized_url).with(headers).
          to_return(:status => 200, :body => "", :headers => {})

        github.send("#{request_type}_request".to_sym, wrong_path, params)
      end
    end
  end
end # Github::Request
