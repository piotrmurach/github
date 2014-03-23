# encoding: utf-8

require 'spec_helper'

describe Github::Client::Activity::Notifications, '#delete' do
  let(:thread_id) { 1 }
  let(:request_path) { "/notifications/threads/#{thread_id}/subscription" }
  let(:body) { '' }
  let(:status) { 204 }

  before {
    subject.oauth_token = OAUTH_TOKEN
    stub_delete(request_path).with(:query => {:access_token => OAUTH_TOKEN}).
    to_return(:body => body, :status => status,
      :headers => { :content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  it { should respond_to :remove }

  it "should delete the resource successfully" do
    subject.delete thread_id
    a_delete(request_path).with(:query => {:access_token => OAUTH_TOKEN}).
      should have_been_made
  end

  it "should fail to delete resource without 'user' parameter" do
    expect { subject.delete }.to raise_error(ArgumentError)
  end

  context 'failed to delete' do
    let(:status) { 404 }

    it "should fail to delete resource that is not found" do
      expect {
        subject.delete thread_id
      }.to raise_error(Github::Error::NotFound)
    end
  end
end # delete
