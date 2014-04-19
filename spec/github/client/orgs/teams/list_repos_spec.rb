# encoding: utf-8

require 'spec_helper'

describe Github::Client::Orgs::Teams, '#list_repos' do
  let(:team_id) { 'github' }
  let(:request_path) { "/teams/#{team_id}/repos" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body) { fixture('orgs/team_repos.json') }
    let(:status) { 200 }

    it "should fail to get resource without team name" do
      expect { subject.list_repos }.to raise_error(ArgumentError)
    end

    it "should get the resources" do
      subject.list_repos team_id
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list_repos team_id }
    end

    it "should get teams information" do
      team_repos = subject.list_repos team_id
      team_repos.first.name.should == 'github'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list_repos(team_id) { |obj| yielded << obj }
      yielded.should == result
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.list_repos team_id }
  end

end # list_repos
