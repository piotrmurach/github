# encoding: utf-8

require 'spec_helper'

describe Github::Client::Orgs::Teams, '#list_members' do
  let(:team_id) { 'github' }
  let(:request_path) { "/teams/#{team_id}/members" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body) { fixture('orgs/teams.json') }
    let(:status) { 200 }

    it "should fail to get resource without org name" do
      expect { subject.list_members }.to raise_error(ArgumentError)
    end

    it "should get the resources" do
      subject.list_members team_id
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list_members team_id }
    end

    it "should get team members information" do
      teams = subject.list_members team_id
      teams.first.name.should == 'Owners'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list_members(team_id) { |obj| yielded << obj }
      yielded.should == result
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.list_members team_id }
  end

end # list_members
