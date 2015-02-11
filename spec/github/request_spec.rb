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

    before do
      expect(params).to receive(:options).exactly(5).times        { { raw: false } }
      expect(params).to receive(:request_params).exactly(2).times { {} }
    end

    it "removes invalid characters before making a request" do
      [:get, :patch, :post, :put, :delete].each do |request_type|
        stub_request(request_type, normalized_url).
          to_return(:status => 200, :body => "", :headers => {})

        github.send("#{request_type}_request".to_sym, wrong_path, params)
      end
    end
  end
end # Github::Request
