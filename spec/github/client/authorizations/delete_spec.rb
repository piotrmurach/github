# encoding: utf-8

require 'spec_helper'

describe Github::Client::Authorizations, '#delete' do
  let(:basic_auth) { 'login:password' }
  let(:host)       { "https://#{basic_auth}@api.github.com" }

  before { subject.basic_auth = basic_auth }

  after { reset_authentication_for(subject) }

  context "when an user" do
    let(:authorization_id) { 1 }
    let(:request_path) { "/authorizations/#{authorization_id}" }
    let(:body) { '' }
    let(:status) { 204 }

    before {
      stub_delete(request_path, host).to_return(body: body, status: status,
        headers: {content_type: 'application/json; charset=utf-8'})
    }

    it "fails to get resource without basic authentication" do
      reset_authentication_for subject
      expect { subject.delete }.to raise_error(ArgumentError)
    end

    it "deletes resource successfully" do
      subject.delete authorization_id
      a_delete(request_path, host).should have_been_made
    end

    it_should_behave_like 'request failure' do
      let(:requestable) { subject.delete authorization_id }
    end
  end
end # delete
