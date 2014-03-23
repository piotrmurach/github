# encoding: utf-8

require 'spec_helper'

describe Github::Client::Gists, '#create' do
  let(:request_path) { "/gists" }

  let(:inputs) {
    {
      "description" => "the description for this gist",
      "public" => true,
      "files" => {
        "file1.txt" => {
          "content" => "String file contents"
        }
      },
    }
  }

  before {
    stub_post(request_path).with(inputs).
      to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce created" do
    let(:body) { fixture('gists/gist.json') }
    let(:status) { 201 }

    it "should fail to create resource if 'files' input is missing" do
      expect {
        subject.create inputs.except('files')
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should fail to create resource if 'public' input is missing" do
      expect {
        subject.create inputs.except('public')
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should create resource successfully" do
      subject.create inputs
      a_post(request_path).with(inputs).should have_been_made
    end

    it "should return the resource" do
      gist = subject.create inputs
      gist.should be_a Github::ResponseWrapper
    end

    it "should get the gist information" do
      gist = subject.create inputs
      gist.user.login.should == 'octocat'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create inputs }
  end

end # create
