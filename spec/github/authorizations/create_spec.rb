# encoding: utf-8

require 'spec_helper'

describe Github::Authorizations, '#create' do
  let(:basic_auth) { 'login:password' }
  let(:request_path) { "/authorizations" }
  let(:host) { "https://#{basic_auth}@api.github.com" }
  let(:inputs) { { :scopes => ['repo'] } }

  before {
    stub_post(request_path, host).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  before { subject.basic_auth = basic_auth }

  after { reset_authentication_for(subject) }

  context "resouce created" do
    let(:body) { fixture('auths/authorization.json') }
    let(:status) { 201 }

    it "should fail to get resource without basic authentication" do
      reset_authentication_for subject
      expect { subject.create }.to raise_error(ArgumentError)
    end

    it "should create resource successfully" do
      subject.create inputs
      a_post(request_path, host).with(inputs).should have_been_made
    end

    it "should return the resource" do
      authorization = subject.create inputs
      authorization.should be_a Github::ResponseWrapper
    end

    it "should get the authorization information" do
      authorization = subject.create inputs
      authorization.token.should == 'abc123'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create inputs }
  end

end # create
