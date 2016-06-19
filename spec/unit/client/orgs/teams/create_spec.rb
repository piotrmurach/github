# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Orgs::Teams, '#create' do
  let(:org)   { 'github' }
  let(:request_path) { "/orgs/#{org}/teams" }

  let(:inputs) {
    { :name => 'new team',
      :permissions => 'push',
      :repo_names => [ 'github/dotfiles' ]
    }
  }

  before {
    stub_post(request_path).with(inputs).
      to_return(body: body, status: status,
      headers: {content_type: 'application/json; charset=utf-8'})
  }

  after { reset_authentication_for(subject) }

  context "resouce created" do
    let(:body) { fixture('orgs/team.json') }
    let(:status) { 201 }

    it "fails to create resource if 'org_name' param is missing" do
      expect { subject.create }.to raise_error(ArgumentError)
    end

    it "fails to create resource if 'name' input is missing" do
      expect {
        subject.create(org, inputs.except(:name))
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "creates resource successfully" do
      subject.create(org, inputs)
      expect(a_post(request_path).with(inputs)).to have_been_made
    end

    it "returns the resource" do
      team = subject.create(org, inputs)
      expect(team).to be_a Github::ResponseWrapper
    end

    it "gets the team information" do
      team = subject.create(org, inputs)
      expect(team.name).to eq('Owners')
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create org, inputs }
  end
end # create
