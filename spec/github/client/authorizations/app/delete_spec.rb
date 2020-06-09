# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Authorizations::App, '#delete' do
  let(:basic_auth)   { 'login:password' }
  let(:host)         { "https://api.github.com" }
  let(:client_id) { 1 }

  subject { described_class.new(basic_auth: basic_auth) }

  before do
    stub_delete(request_path, host).to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  end

  context "when app revokes all tokens" do
    let(:request_path) { "/applications/#{client_id}/tokens" }
    let(:body) { '' }
    let(:status) { 204 }

    it "fails to get resource without basic authentication" do
      reset_authentication_for subject
      expect { subject.delete }.to raise_error(ArgumentError)
    end

    it "revokes resource successfully" do
      subject.delete client_id
      expect(a_delete(request_path, host)).to have_been_made
    end

    it_should_behave_like 'request failure' do
      let(:requestable) { subject.delete client_id }
    end
  end

  context 'when app revokes a token' do
    let(:access_token) { 'abcdef'}
    let(:request_path) { "/applications/#{client_id}/tokens/#{access_token}" }
    let(:body) { '' }
    let(:status) { 204 }

    it "revokes resource successfully" do
      subject.delete client_id, access_token
      expect(a_delete(request_path, host)).to have_been_made
    end

    it "revokes resource successfully with access token as parameter" do
      subject.delete client_id, access_token: access_token
      expect(a_delete(request_path, host)).to have_been_made
    end

    it_should_behave_like 'request failure' do
      let(:requestable) { subject.delete client_id, access_token }
    end
  end
end # delete
