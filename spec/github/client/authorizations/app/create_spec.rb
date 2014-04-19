# encoding: utf-8

require 'spec_helper'

describe Github::Client::Authorizations::App, '#create' do
  let(:basic_auth) { 'login:password' }
  let(:host)       { "https://#{basic_auth}@api.github.com" }
  let(:inputs)     { { :scopes => ['repo'] } }
  let(:request_path) { "/authorizations/clients/#{client_id}" }

  before {
    subject.basic_auth = basic_auth

    stub_put(request_path, host).to_return(body: body, status: status,
      headers: {content_type: 'application/json; charset=utf-8'})
  }

  after { reset_authentication_for(subject) }

  context 'when app creates token' do
    let(:body)      { fixture('auths/authorization.json') }
    let(:status)    { 201 }
    let(:client_id) { 1 }

    it "creates resource successfully" do
      subject.create client_id
      a_put(request_path, host).should have_been_made
    end

    it "fails without client_id" do
      expect { subject.create }.to raise_error(ArgumentError)
    end

    it "returns the resource" do
      authorization = subject.create client_id
      authorization.should be_a Github::ResponseWrapper
    end

    it "gets the authorization information" do
      authorization = subject.create client_id
      authorization.token.should == 'abc123'
    end
  end
end # create
