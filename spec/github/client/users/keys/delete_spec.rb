# encoding: utf-8

require 'spec_helper'

describe Github::Client::Users::Keys, '#delete' do
  let(:key_id) { 1 }
  let(:request_path) { "/user/keys/#{key_id}" }

  before {
    subject.oauth_token = OAUTH_TOKEN
      stub_delete(request_path).with(:query => {:access_token => OAUTH_TOKEN}).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce deleted" do
    let(:body) { fixture('users/key.json') }
    let(:status) { 204 }

    it "should fail to get resource without key id" do
      expect { subject.delete }.to raise_error(ArgumentError)
    end

    it "should create resource successfully" do
      subject.delete key_id
      a_delete(request_path).with(:query => {:access_token => OAUTH_TOKEN}).
        should have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.delete key_id }
  end

end # delete
