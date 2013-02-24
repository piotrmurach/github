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

    it { expect { subject.create }.to raise_error(ArgumentError) }

    it { expect { subject.create user }.to raise_error(ArgumentError) }

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
      download.should be_a Github::ResponseWrapper
    end

    it "should get the download information" do
      download = subject.create user, repo, inputs
      download.name.should == 'new_file.jpg'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create user, repo, inputs }
  end

end # create
