# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Orgs::Teams, '#list_repos' do
  let(:team_id) { 'github' }
  let(:request_path) { "/teams/#{team_id}/repos" }

  before do
    stub_get(request_path).to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  end

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body) { fixture('orgs/team_repos.json') }
    let(:status) { 200 }

    it "fails to get resource without team name" do
      expect { subject.list_repos }.to raise_error(ArgumentError)
    end

    it "gets the resources" do
      subject.list_repos team_id
      expect(a_get(request_path)).to have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list_repos team_id }
    end

    it "gets teams information" do
      team_repos = subject.list_repos team_id
      expect(team_repos.first.name).to eq('github')
    end

    it "yields to a block" do
      yielded = []
      result = subject.list_repos(team_id) { |obj| yielded << obj }
      expect(yielded).to eq(result)
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.list_repos team_id }
  end
end # list_repos
