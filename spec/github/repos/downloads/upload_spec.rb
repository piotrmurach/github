# encoding: utf-8

require 'spec_helper'
require 'github_api/s3_uploader'

describe Github::Repos::Downloads do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }

  after { reset_authentication_for(subject) }

  let(:resource) { stub(:resource) }
  let(:filename) { 'filename' }
  let(:res)      { stub(:response, :body => 'success') }
  let(:uploader) { stub(:uploader, :send => res) }

  before { Github::S3Uploader.stub(:new) { uploader } }

  it "should fail if resource is of incorrect type" do
    expect {
      subject.upload resource, nil
    }.to raise_error(ArgumentError)
  end

  it "should upload resource successfully" do
    res = stub(:response, :body => 'success')
    uploader = stub(:uploader, :send => res)
    Github::S3Uploader.should_receive(:new).with(resource, filename) { uploader }
    subject.upload(resource, filename).should == 'success'
  end
end # upload

