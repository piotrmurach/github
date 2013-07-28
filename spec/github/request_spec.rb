# encoding: utf-8

require 'spec_helper'

describe Github::Request do
  let(:github)   { Github::API.new  }
  let(:path)     { 'github.api/repos/users' }
  let(:params)   { {} }
  let(:response) { double('response').as_null_object }

  it "knows how to make get request" do
    github.should_receive(:request).with(:get, path, params) { response }
    github.get_request path, params
  end

  it "knows how to make patch request" do
    github.should_receive(:request).with(:patch, path, params)
    github.patch_request path, params
  end

  it "knows how to make post request" do
    github.should_receive(:request).with(:post, path, params)
    github.post_request path, params
  end

  it "knows how to make put request" do
    github.should_receive(:request).with(:put, path, params)
    github.put_request path, params
  end

  it "knows how to make delete request" do
    github.should_receive(:request).with(:delete, path, params)
    github.delete_request path, params
  end
end # Github::Request
