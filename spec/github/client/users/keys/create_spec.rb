# encoding: utf-8

require 'spec_helper'

describe Github::Client::Users::Keys, '#create' do
  let(:request_path) { "/user/keys" }

  before {
    subject.oauth_token = OAUTH_TOKEN
      stub_post(request_path).with(:body => inputs.except(:unrelated),
        :query => {:access_token => OAUTH_TOKEN}).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  let(:inputs) {
    {
      :title => "octocat@octomac",
      :key => "ssh-rsa AAA...",
      :unrelated => true
    }
  }

  context "resouce created" do
    let(:body) { fixture('users/key.json') }
    let(:status) { 201 }

    it "should create resource successfully" do
      subject.create inputs
      a_post(request_path).with(:body => inputs.except(:unrelated),
        :query => {:access_token => OAUTH_TOKEN}).should have_been_made
    end

    it "should return the resource" do
      key = subject.create inputs
      key.should be_a Github::ResponseWrapper
    end

    it "should get the key information" do
      key = subject.create inputs
      key.title.should == 'octocat@octomac'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create inputs }
  end

end # create
