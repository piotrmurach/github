# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Deployments, '#create_status' do
  let(:user)   { 'nahiluhmot' }
  let(:repo)   { 'github' }
  let(:id)     { 12147 }
  let(:request_path) { "/repos/#{user}/#{repo}/deployments/#{id}/statuses" }
  let(:params) {
    {
      'state' => 'success'
    }
  }

  before {
    stub_post(request_path).with(:body => params).
      to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce created" do
    let(:body) { fixture('repos/deployment_status.json') }
    let(:status) { 201 }

    it "should fail to create resource if 'state' input is missing" do
      expect {
        subject.create_status user, repo, id, params.except('state')
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should create resource successfully" do
      subject.create_status user, repo, id, params
      a_post(request_path).with(:body => params).should have_been_made
    end

    it "should return the resource" do
      status = subject.create_status user, repo, id, params
      status.should be_a Github::ResponseWrapper
    end

    it "should get the deployment information" do
      status = subject.create_status user, repo, id, params
      status.state.should == 'success'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create_status user, repo, id, params }
  end

end # create_status
