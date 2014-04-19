# encoding: utf-8

require 'spec_helper'

describe Github::Client::Orgs::Teams, '#add_repo' do
  let(:team_id) { 1 }
  let(:repo) { 'github' }
  let(:user) { 'peter-murach' }
  let(:request_path) { "/teams/#{team_id}/repos/#{user}/#{repo}" }

  before {
    stub_put(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce added" do
    let(:body) { '' }
    let(:status) { 204 }

    it "should fail to add resource if 'team_id' input is nil" do
      expect { subject.add_repo nil, user, repo }.to raise_error(ArgumentError)
    end

    it "should fail to add resource if 'user' input is nil" do
      expect { subject.add_repo team_id, nil, repo }.to raise_error(ArgumentError)
    end

    it "should add resource successfully" do
      subject.add_repo team_id, user, repo
      a_put(request_path).should have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.add_repo team_id, user, repo }
  end
end # add_repo
