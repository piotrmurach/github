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
end # Github::Request
