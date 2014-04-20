# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Hooks, '#create' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/hooks" }
  let(:inputs) {
    {
      'name' => 'web',
      'config' => {
        'url' => "http://something.com/webhook",
        'address' => "test@example.com",
        'subdomain' => "github",
        'room' => "Commits",
        'token' => "abc123"
      },
      'active' => true,
      'unrelated' => true
    }
  }

  before {
    stub_post(request_path).with(inputs.except('unrelated')).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce created" do
    let(:body) { fixture('repos/hook.json') }
    let(:status) { 201 }

    it "should fail to create resource if 'name' input is missing" do
      expect {
        subject.create user, repo, inputs.except('name')
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should failt to create resource if 'config' input is missing" do
      expect {
        subject.create user, repo, inputs.except('config')
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should create resource successfully" do
      subject.create user, repo, inputs
      a_post(request_path).with(inputs).should have_been_made
    end

    it "should return the resource" do
      hook = subject.create user, repo, inputs
      hook.should be_a Github::ResponseWrapper
    end

    it "should get the hook information" do
      hook = subject.create user, repo, inputs
      hook.name.should == 'web'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create user, repo, inputs }
  end
end # create
