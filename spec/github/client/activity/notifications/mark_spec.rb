# encoding: utf-8

require 'spec_helper'

describe Github::Client::Activity::Notifications, '#mark' do
  let(:body) { '[]' }
  let(:status) { 205 }
  let(:inputs) { {
    :read => true,
    :unread => false,
    :last_read_at => "2012-10-09T23:39:01Z"
  }}

  before { subject.oauth_token = OAUTH_TOKEN }

  after { reset_authentication_for subject }

  context 'an authenticate user' do
    let(:request_path) { '/notifications'}

    before {
      stub_put(request_path).
      with(:body => inputs, :query => {:access_token => OAUTH_TOKEN }).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
    }

    it 'should get the resource' do
      subject.mark inputs.merge(:unknown => true)
      a_put(request_path).
        with(:body => inputs, :query => {:access_token => OAUTH_TOKEN}).
        should have_been_made
    end
  end

  context 'in a repository' do
    let(:user) { 'peter-murach' }
    let(:repo) { 'github' }
    let(:request_path) { "/repos/#{user}/#{repo}/notifications" }

    before {
      stub_put(request_path).
      with(:body => inputs, :query => {:access_token => OAUTH_TOKEN }).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
    }

    it 'should get the resource' do
      subject.mark inputs.merge(:user => user, :repo => repo)
      a_put(request_path).
        with(:body => inputs, :query => {:access_token => OAUTH_TOKEN}).
        should have_been_made
    end
  end

  context 'a thread' do
    let(:thread_id) { 1 }
    let(:request_path) { "/notifications/threads/#{thread_id}" }

    before {
      stub_patch(request_path).
      with(:body => inputs, :query => {:access_token => OAUTH_TOKEN }).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
    }

    it 'should get the resource' do
      subject.mark inputs.merge(:id => thread_id)
      a_patch(request_path).
        with(:body => inputs, :query => {:access_token => OAUTH_TOKEN}).
        should have_been_made
    end
  end
end # mark
