# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Orgs::Teams, '#edit' do
  let(:team)   { 'github' }
  let(:request_path) { "/teams/#{team}" }

  let(:inputs) {
    { :name => 'new team',
      :permissions => 'push',
    }
  }

  before do
    stub_patch(request_path).with(inputs).
      to_return(body: body, status: status,
      headers: {content_type: 'application/json; charset=utf-8'})
  end

  after { reset_authentication_for(subject) }

  context "resouce edited" do
    let(:body) { fixture('orgs/team.json') }
    let(:status) { 200 }

    it "fails to create resource if 'team name' param is missing" do
      expect { subject.edit }.to raise_error(ArgumentError)
    end

    it "fails to create resource if 'name' input is missing" do
      expect {
        subject.edit(team, inputs.except(:name))
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "edits resource successfully" do
      subject.edit(team, inputs)
      expect(a_patch(request_path).with(inputs)).to have_been_made
    end

    it "returns the resource" do
      edited_team = subject.edit(team, inputs)
      expect(edited_team).to be_a(Github::ResponseWrapper)
    end

    it "gets the team information" do
      edited_team = subject.edit(team, inputs)
      expect(edited_team.name).to eq('Owners')
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.edit team, inputs }
  end
end # edit
