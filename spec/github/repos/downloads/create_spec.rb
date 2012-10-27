# encoding: utf-8

require 'spec_helper'

describe Github::Repos::Downloads, '#create' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/downloads" }
  let(:inputs) { {
    :name => 'new_file.jpg',
    :size => 114034,
    :description => "Latest release",
    :content_type => 'text/plain'}
  }

  after { reset_authentication_for(subject) }

  before {
    stub_post(request_path).with(inputs).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
  }

  context "resouce created" do
    let(:body)   { fixture('repos/download_s3.json') }
    let(:status) { 201}

    it "should fail to create resource if 'name' input is missing" do
      expect {
        subject.create user, repo, inputs.except(:name)
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should failt to create resource if 'size' input is missing" do
      expect {
        subject.create user, repo, inputs.except(:size)
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should create resource successfully" do
      subject.create user, repo, inputs
      a_post(request_path).with(inputs).should have_been_made
    end

    it "should return the resource" do
      download = subject.create user, repo, inputs
      download.should be_a Hashie::Mash
    end

    it "should get the download information" do
      download = subject.create user, repo, inputs
      download.name.should == 'new_file.jpg'
    end
  end

  context "failed to create resource" do
    let(:body)   { "" }
    let(:status) { [404, "Not Found"] }

    it "should faile to retrieve resource" do
      expect {
        subject.create user, repo, inputs
      }.to raise_error(Github::Error::NotFound)
    end
  end
end # create
