# encoding: utf-8

require 'spec_helper'

describe Github::Client::Orgs::Teams, '#get' do
  let(:team)   { 'github' }
  let(:request_path) { "/teams/#{team}" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body) { fixture('orgs/team.json') }
    let(:status) { 200 }

    it "should fail to get resource without org name" do
      expect { subject.get }.to raise_error(ArgumentError)
    end

    it "should get the resource" do
      subject.get team
      a_get(request_path).should have_been_made
    end

    it "should get team information" do
      team_res = subject.get team
      team_res.id.should == 1
      team_res.name.should == 'Owners'
    end

    it "should return mash" do
      team_res = subject.get team
      team_res.should be_a Github::ResponseWrapper
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get team }
  end
end # get
