# encoding: utf-8

require 'spec_helper'

describe Github::Client::Orgs::Teams, '#team_repo?' do
  let(:team_id) { 1 }
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/teams/#{team_id}/repos/#{user}/#{repo}" }
  let(:body) { '' }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context 'when repo is managed by this team' do
    let(:status) { 204 }

    it "should fail validation " do
      expect {
        subject.team_repo?(team_id, user, nil)
      }.to raise_error(ArgumentError)
    end

    it "should return true if resoure found" do
      team_managed = subject.team_repo? team_id, user, repo
      team_managed.should be_true
    end
  end

  context 'when repo is not managed by this team' do
    let(:status) { 404 }

    it "should return false if resource not found" do
      team_managed = subject.team_repo? team_id, user, repo
      team_managed.should be_false
    end
  end
end # team_repo?
