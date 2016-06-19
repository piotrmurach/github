# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Orgs::Teams, '#get' do
  let(:team)   { 'github' }
  let(:request_path) { "/teams/#{team}" }

  before do
    stub_get(request_path).to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  end

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body) { fixture('orgs/team.json') }
    let(:status) { 200 }

    it "fails to get resource without org name" do
      expect { subject.get }.to raise_error(ArgumentError)
    end

    it "gets the resource" do
      subject.get team
      expect(a_get(request_path)).to have_been_made
    end

    it "gets team information" do
      team_res = subject.get(team)
      expect(team_res.id).to eq(1)
      expect(team_res.name).to eq('Owners')
    end

    it "should return mash" do
      team_res = subject.get(team)
      expect(team_res).to be_a Github::ResponseWrapper
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get team }
  end
end # get
