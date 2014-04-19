# encoding: utf-8

require 'spec_helper'

describe Github::Client::Users::Keys, '#update' do
  let(:key_id) { 1 }
  let(:request_path) { "/user/keys/#{key_id}" }

  before {
    subject.oauth_token = OAUTH_TOKEN
    stub_patch(request_path).with(:body => inputs.except(:unrelated),
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

  context "resouce updated" do
    let(:body) { fixture('users/key.json') }
    let(:status) { 201 }

    it "should fail to get resource without key id" do
      expect { subject.update }.to raise_error(ArgumentError)
    end

    it "should create resource successfully" do
      subject.update key_id, inputs
      a_patch(request_path).with(:body => inputs.except(:unrelated),
        :query => {:access_token => OAUTH_TOKEN}).should have_been_made
    end

    it "should return the resource" do
      key = subject.update key_id, inputs
      key.should be_a Github::ResponseWrapper
    end

    it "should get the key information" do
      key = subject.update key_id, inputs
      key.title.should == 'octocat@octomac'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.update key_id, inputs }
  end

end # update
