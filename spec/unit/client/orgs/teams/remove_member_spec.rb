# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Orgs::Teams, '#remove_member' do
  let(:team_id)   { 1 }
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/teams/#{team_id}/members/#{user}"}

  before do
    stub_delete(request_path).to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  end

  after { reset_authentication_for(subject) }

  context "resouce deleted" do
    let(:body) { '' }
    let(:status) { 204 }

    it "fails to delete resource if 'team_id' input is nil" do
      expect { subject.remove_member nil, user }.to raise_error(ArgumentError)
    end

    it "fails to delete resource if 'user' input is nil" do
      expect { subject.remove_member team_id, nil }.to raise_error(ArgumentError)
    end

    it "adds resource successfully" do
      subject.remove_member team_id, user
      expect(a_delete(request_path)).to have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.remove_member team_id, user }
  end
end # remove_member
