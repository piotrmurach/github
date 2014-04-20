# encoding: utf-8

require 'spec_helper'

describe Github::Client::Activity::Notifications, '#create' do
  let(:thread_id) { 1 }
  let(:request_path) { "/notifications/threads/#{thread_id}/subscription" }

  let(:inputs) {{
    :subscribed => true,
    :ignored => false
  }}

  before {
    subject.oauth_token = OAUTH_TOKEN
    stub_put(request_path).
      with(:body => inputs, :query => {:access_token => OAUTH_TOKEN}).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"} )
  }

  after { reset_authentication_for subject }

  context "resource created successfully" do
    let(:body)  { fixture('activity/subscribed.json') }
    let(:status) { 200 }

    it 'asserts thread id presence' do
      expect { subject.create }.to raise_error(ArgumentError)
    end

    it 'should create resource' do
      subject.create thread_id, inputs
      a_put(request_path).
        with(:body => inputs, :query => {:access_token => OAUTH_TOKEN}).
        should have_been_made
    end

    it 'should return the resource' do
      thread = subject.create thread_id, inputs
      thread.subscribed.should be_true
    end
  end
end # create
