# encoding: utf-8

require 'spec_helper'

describe Github::Client::Users::Followers, '#unfollow' do
  let(:request_path) { "/user/following/#{user}" }
  let(:user)   { 'peter-murach' }
  let(:body) { '[]' }
  let(:status) { 204 }

  before {
    subject.oauth_token = OAUTH_TOKEN
    stub_delete(request_path).with(:query => {:access_token => OAUTH_TOKEN}).
    to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  it "should raise error if gist id not present" do
    expect { subject.unfollow }.to raise_error(ArgumentError)
  end

  it 'successfully unfollows a user' do
    subject.unfollow(user)
    expect(a_delete(request_path).with(:query => { :access_token => OAUTH_TOKEN})).
      to have_been_made
  end

  it "should return 204 with a message 'Not Found'" do
    expect(subject.unfollow(user).status).to be 204
  end
end # unfollow
