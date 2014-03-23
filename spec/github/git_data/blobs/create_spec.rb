# encoding: utf-8

require 'spec_helper'

describe Github::Client::GitData::Blobs, '#create' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:sha) { "3a0f86fb8db8eea7ccbb9a95f325ddbedfb25e15" }
  let(:request_path) { "/repos/#{user}/#{repo}/git/blobs" }
  let(:inputs) {
    {
      "content" => "Content of the blob",
      "encoding" =>  "utf-8",
      "unrelated" => 'giberrish'
    }
  }

  before {
    stub_post(request_path).with(inputs.except('unrelated')).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce created" do
    let(:body) { fixture('git_data/blob_sha.json') }
    let(:status) { 201 }

    it { expect { subject.create user }.to raise_error(ArgumentError) }

    it "should fail to create resource if 'content' input is missing" do
      expect {
        subject.create user, repo, inputs.except('content')
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should fail to create resource if 'encoding' input is missing" do
      expect {
        subject.create user, repo, inputs.except('encoding')
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should create resource successfully" do
      subject.create user, repo, inputs
      a_post(request_path).with(inputs).should have_been_made
    end

    it "should return the resource" do
      blob_sha = subject.create user, repo, inputs
      blob_sha.should be_a Github::ResponseWrapper
    end

    it "should get the blob information" do
      blob_sha = subject.create user, repo, inputs
      blob_sha.sha.should == sha
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create user, repo, inputs }
  end

end # create
