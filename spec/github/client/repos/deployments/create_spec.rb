# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Deployments, '#create' do
  let(:user)   { 'nahiluhmot' }
  let(:repo)   { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/deployments" }
  let(:params) {
    {
      'ref' => 'a9a5ad01cf26b646e6f95bf9e2d13a2a155b5c9b',
      'description' => 'Test deploy'
    }
  }

  before {
    stub_post(request_path).with(:body => params).
      to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce created" do
    let(:body) { fixture('repos/deployment.json') }
    let(:status) { 201 }

    it "should fail to create resource if 'ref' input is missing" do
      expect {
        subject.create user, repo, params.except('ref')
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should create resource successfully" do
      subject.create user, repo, params
      a_post(request_path).with(:body => params).should have_been_made
    end

    it "should return the resource" do
      deployment = subject.create user, repo, params
      deployment.should be_a Github::ResponseWrapper
    end

    it "should get the deployment information" do
      deployment = subject.create user, repo, params
      deployment.environment.should == 'production'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create user, repo, params }
  end

end # create
