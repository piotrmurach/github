# encoding: utf-8

require 'spec_helper'

describe Github::Authorizations, '#delete' do
  let(:basic_auth) { 'login:password' }
  let(:request_path) { "/authorizations/#{authorization_id}" }
  let(:host) { "https://#{basic_auth}@api.github.com" }
  let(:authorization_id) { 1 }

  before {
    stub_delete(request_path, host).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  before { subject.basic_auth = basic_auth }

  after { reset_authentication_for(subject) }

  context "resouce deleted" do
    let(:body) { '' }
    let(:status) { 204 }

    it "should fail to get resource without basic authentication" do
      reset_authentication_for subject
      expect { subject.delete }.to raise_error(ArgumentError)
    end

    it "should delete resource successfully" do
      subject.delete authorization_id
      a_delete(request_path, host).should have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.delete authorization_id }
  end

end # delete
