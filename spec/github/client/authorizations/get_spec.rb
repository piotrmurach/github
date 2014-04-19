# encoding: utf-8

require 'spec_helper'

describe Github::Client::Authorizations, '#get' do
  let(:basic_auth) { 'login:password' }
  let(:request_path) { "/authorizations/#{authorization_id}" }
  let(:host) { "https://#{basic_auth}@api.github.com" }
  let(:authorization_id) { 1 }

  before {
    stub_get(request_path, host).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  before { subject.basic_auth = basic_auth }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body) { fixture('auths/authorization.json') }
    let(:status) { 200 }

    it "should fail to get resource without authorization id" do
      expect { subject.get }.to raise_error(ArgumentError)
    end

    it "should get the resource" do
      subject.get authorization_id
      a_get(request_path, host).should have_been_made
    end

    it "should get authorization information" do
      authorization = subject.get authorization_id
      authorization.id.should == authorization_id
      authorization.token.should == 'abc123'
    end

    it "should return mash" do
      authorization = subject.get authorization_id
      authorization.should be_a Github::ResponseWrapper
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get authorization_id }
  end
end # list
