# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Github::Client::Projects, '#edit' do
  let(:project_id)   { 1002604 }
  let(:request_path) { "/projects/#{project_id}" }
  let(:body) { fixture("projects/project.json") }
  let(:status) { 200 }
  let(:inputs) {
    {
      "name" => 'Outcomes Tracker',
      "body" => "The board to track work for the Outcomes application."
    }
  }

  before do
    stub_patch(request_path).with(inputs).
      to_return(body: body, status: status,
      headers: {content_type: 'application/json; charset=utf-8'})
  end

  after { reset_authentication_for(subject) }

  context "resource edited successfully" do
    it "fails to edit without id parameter" do
      expect { subject.edit }.to raise_error(ArgumentError)
    end

    it "edits the resource" do
      subject.edit(project_id, inputs)
      expect(a_patch(request_path).with(inputs)).to have_been_made
    end

    it "returns resource" do
      project = subject.edit project_id, inputs
      expect(project).to be_a Github::ResponseWrapper
    end

    it "retrieves information" do
      project = subject.edit project_id
      expect(project.name).to eq('Projects Documentation')
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.edit project_id }
  end
end # edit
