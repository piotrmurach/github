# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Keys, '#create' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/keys" }
  let(:inputs) { {:title => "octocat@octomac", :key => "ssh-rsa AAA..." } }

  before {
    stub_post(request_path).with(inputs).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource created" do
    let(:body) { fixture("repos/key.json") }
    let(:status) { 201 }

    it "should fail to create resource if 'title' input is missing" do
      expect {
        subject.create user, repo, :key => 'ssh-rsa AAA...'
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should fail to create resource if 'key' input is missing" do
      expect {
        subject.create user, repo, :title => 'octocat@octomac'
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should create the resource" do
      subject.create user, repo, inputs
      a_post(request_path).with(inputs).should have_been_made
    end

    it "should get the key information back" do
      key = subject.create user, repo, inputs
      key.title.should == 'octocat@octomac'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create user, repo, inputs }
  end
end # create
