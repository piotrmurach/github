# encoding: utf-8

require 'spec_helper'

describe Github::Client::Scopes, '#list' do
  let(:request_path) { "/user" }
  let(:body) { '[]' }
  let(:status) { 200 }
  let(:accepted_scopes) { "delete_repo, repo, public_repo, repo:status" }
  let(:scopes) { 'repo' }

  before {
    subject.oauth_token = OAUTH_TOKEN
    stub_get(request_path).
      with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8",
'x-accepted-oauth-scopes' => accepted_scopes, 'x-oauth-scopes' => 'repo'
      })
  }

  after { reset_authentication_for(subject) }

  it 'performs request' do
    subject.list
    a_get(request_path).with(:query => {:access_token => OAUTH_TOKEN}).
      should have_been_made
  end

  it 'queries oauth header' do
    subject.list.should == [scopes]
  end
end # list
