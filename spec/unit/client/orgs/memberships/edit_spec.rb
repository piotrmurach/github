# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Orgs::Memberships, '#edit' do
  let(:orgname) { 'github' }
  let(:status) { 200 }
  let(:body) { fixture('orgs/membership.json') }
  let(:request_path) { "/user/memberships/orgs/#{orgname}" }

  before {
    stub_patch(request_path).with(body: {state: 'active'}).
      to_return(body: body, status: status,
      headers: {content_type: 'application/json; charset=utf-8'})
  }

  after { reset_authentication_for(subject) }

  it 'edits organization membership' do
    subject.edit(orgname, state: 'active')
    expect(a_patch(request_path)).to have_been_made
  end

  it 'should create organization membership with role member' do
    response = subject.edit(orgname, state: 'active')
    expect(response.role).to eq('admin')
  end

  it "failse without role option" do
    expect {
      subject.edit(orgname)
    }.to raise_error(Github::Error::RequiredParams,
                      /Required parameters are: state/)
  end
end # edit
