# encoding: utf-8

require 'spec_helper'

describe Github::Client::Users::Followers, '#following?' do
  let(:request_path) { "/user/following/#{user}" }
  let(:user)   { 'peter-murach' }
  let(:body) { '[]' }
  let(:status) { 204 }

  before {
    subject.oauth_token = OAUTH_TOKEN
    stub_get(request_path).with(:query => {:access_token => OAUTH_TOKEN}).
    to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  it 'should raise error if username not present' do
    expect { subject.following? }.to raise_error(ArgumentError)
  end

  it 'should perform request' do
    subject.following?(user)
    expect(a_get(request_path).with(:query => { :access_token => "#{OAUTH_TOKEN}"})).
      to have_been_made
  end

  it 'should return true if user is being followed' do
    expect(subject.following?(user)).to be true
  end

  it 'should return false if user is not being followed' do
    stub_get("/user/following/#{user}").
      with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
      to_return(:body => '',:status => 404,
        :headers => {:content_type => "application/json; charset=utf-8"})
    expect(subject.following?(user)).to be false
  end
end # following?
