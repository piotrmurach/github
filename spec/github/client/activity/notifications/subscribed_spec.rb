# encoding: utf-8

require 'spec_helper'

describe Github::Client::Activity::Notifications, '#subscribed?' do
  let(:thread_id) { 1 }
  let(:request_path) { "/notifications/threads/#{thread_id}/subscription" }

  before {
    subject.oauth_token = OAUTH_TOKEN
    stub_get(request_path).with(:query => {:access_token => OAUTH_TOKEN}).
    to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  context 'resource found for authenticated user' do
    let(:body)   { fixture('activity/subscribed.json') }
    let(:status) { 200 }

    it 'asserts thread id presence' do
      expect { subject.subscribed? }.to raise_error(ArgumentError)
    end

    it 'gets the resource' do
      subject.subscribed? thread_id
      a_get(request_path).with(:query => {:access_token => OAUTH_TOKEN }).
        should have_been_made
    end

    it 'gets resource information' do
      subscribed = subject.subscribed? thread_id
      subscribed.subscribed.should be_true
    end
  end

  context "resource not found for a user" do
    let(:body) { '' }
    let(:status) { [404, "Not Found"] }

    it "should return 404 with a message 'Not Found'" do
      expect {
        subject.subscribed? thread_id
      }.to raise_error(Github::Error::NotFound)
    end
  end
end # subscribed
