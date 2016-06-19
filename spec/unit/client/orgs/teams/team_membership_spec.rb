# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Orgs::Teams, '#team_member?' do
  let(:team_id) { 1 }
  let(:user) { 'peter-murach' }
  let(:request_path) { "/teams/#{team_id}/memberships/#{user}" }
  let(:body) { '' }

  before do
    stub_get(request_path).to_return(body: body, status: status,
      headers: {content_type: 'application/json; charset=utf-8'})
  end

  after { reset_authentication_for(subject) }

  context 'when user is a member' do
    let(:status) { 204 }

    it "fails without username" do
      expect {
        subject.team_membership(team_id, nil)
      }.to raise_error(ArgumentError)
    end

    it "fails validation " do
      expect { subject.team_membership }.to raise_error(ArgumentError)
    end

    it "returns true if resoure found" do
      team_membership = subject.team_membership(team_id, user)
      expect(team_membership).to be_true
    end
  end
end # team_membership
