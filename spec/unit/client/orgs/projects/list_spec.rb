# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Orgs::Projects, '#list' do
  let(:org) { 'API-sampler' }
  let(:request_path) { "/orgs/#{org}/projects" }

  before do
    stub_get(request_path).to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  end

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body) { fixture('orgs/projects.json') }
    let(:status) { 200 }

    it { expect(subject).to respond_to :all }

    it { expect { subject.list }.to raise_error(ArgumentError) }

    it "gets the resources" do
      subject.list(org)
      expect(a_get(request_path)).to have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list org }
    end

    it "gets project information" do
      projects = subject.list(org)
      expect(projects.first.name).to eq('Organization Roadmap')
    end

    it "yields to a block" do
      yielded = []
      result = subject.list(org) { |obj| yielded << obj }
      expect(yielded).to eq(result)
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.list org }
  end
end # list
