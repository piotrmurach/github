# encoding: utf-8

require 'spec_helper'

describe Github::Client::Users::Keys, '#get' do
  let(:key_id) { 1 }
  let(:request_path) { "/user/keys/#{key_id}" }

  before {
    subject.oauth_token = OAUTH_TOKEN
    stub_get(request_path).with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
      to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found for an authenticated user" do
    let(:body) { fixture('users/key.json') }
    let(:status) { 200 }

    it { should respond_to :find }

    it "should fail to get resource without key id" do
      expect { subject.get }.to raise_error(ArgumentError)
    end

    it "should get the resource" do
      subject.get key_id
      a_get(request_path).with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
        should have_been_made
    end

    it "should get public key information" do
      key = subject.get key_id
      key.id.should == key_id
      key.title.should == 'octocat@octomac'
    end

    it "should return mash" do
      key = subject.get key_id
      key.should be_a Github::ResponseWrapper
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get key_id }
  end

end # get
