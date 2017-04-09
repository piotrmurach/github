# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Orgs::Memberships, '#create' do
  let(:orgname) { 'CodeCu' }
  let(:status) { 200 }

  before {
    stub_put(request_path).with(body: inputs).
      to_return(body: body, status: status,
      headers: {content_type: 'application/json; charset=utf-8'})
  }

  after { reset_authentication_for(subject) }

  context 'Add/update organization membership - unaffiliated user' do
    let(:username) { 'anujaware' }
    let(:request_path) { "/orgs/#{orgname}/memberships/#{username}" }
    let(:body) { fixture('orgs/membership_to_unaffiliated_user.json') }
    let(:inputs) {{role: 'member'}}

    it 'should create organization membership with pending state' do
      response = subject.create(orgname, username, inputs)
      expect(response.state).to eq('pending')
    end

    it 'should create organization membership with role member' do
      response = subject.create orgname, username, inputs
      expect(response.role).to eq('member')
    end

    it "failse without role option" do
      expect {
        subject.create(orgname, username)
      }.to raise_error(Github::Error::RequiredParams,
                       /Required parameters are: role/)
    end
  end

  context 'Add/update organization membership - affiliated user' do
    let(:username) { 'anuja-joshi' }
    let(:request_path) { "/orgs/#{orgname}/memberships/#{username}" }
    let(:body) { fixture('orgs/membership_to_affilliated_user.json') }
    let(:inputs) {{role: 'admin'}}

    it 'should create organization membership with active state' do
      response = subject.create(orgname, username, inputs)
      expect(response.state).to eq('active')
    end

    it 'should update organization membership with role admin' do
      response = subject.create(orgname, username, inputs)
      expect(response.role).to eq('admin')
    end
  end
end # create
