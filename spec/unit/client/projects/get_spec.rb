# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Github::Client::Projects, '#get' do
  let(:project_id)   { 1002604 }
  let(:request_path) {  "/projects/1002604" }
  let(:body) { fixture('projects/project.json') }
  let(:status) { 200 }

  before do
    stub_get(request_path).to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  end

  after { reset_authentication_for(subject) }

  context "resource found" do
    it "fails to get resource without project id" do
      expect { subject.get }.to raise_error(ArgumentError)
    end

    it "gets the resource" do
      subject.get(project_id)
      expect(a_get(request_path)).to have_been_made
    end

    it "gets project information" do
      project = subject.get project_id
      expect(project.id).to eq project_id
      expect(project.name).to eq('Projects Documentation')
    end

    it "returns response wrapper" do
      project = subject.get project_id
      expect(project).to be_a Github::ResponseWrapper
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get project_id }
  end
end # get
