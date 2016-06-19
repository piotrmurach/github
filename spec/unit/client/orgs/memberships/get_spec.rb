# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Orgs::Memberships, '#get' do
  let(:org) { 'github' }
  let(:username) { 'piotr' }
  let(:body) { fixture('orgs/membership.json') }
  let(:status) { 200 }

  before {
    stub_get(request_path).to_return(body: body, status: status,
      headers: {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "for a user" do
    let(:request_path) { "/orgs/#{org}/memberships/#{username}" }

    it "should fail to get resource without org name" do
      expect { subject.get }.to raise_error(ArgumentError)
    end

    it "gets the resource" do
      subject.get(org, username: username)
      expect(a_get(request_path)).to have_been_made
    end

    it "gets organization information" do
      org_response = subject.get(org, username: username)
      expect(org_response.state).to eq('active')
    end
  end

  context "for the authenticated user" do
    let(:request_path) { "/user/memberships/orgs/#{org}" }

    it "gets the resource" do
      subject.get(org)
      expect(a_get(request_path)).to have_been_made
    end
  end
end # get
