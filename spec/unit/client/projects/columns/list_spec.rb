# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Github::Client::Projects::Columns, '#list' do
  let(:project_id) { 120 }
  let(:request_path) { "/projects/#{project_id}/columns" }

  before do
    stub_get(request_path)
      .with(headers: { 'Accept' => 'application/vnd.github.inertia-preview+json' })
      .to_return(
        body: body,
        status: status,
        headers: {
          content_type: "application/json; charset=utf-8"
        }
      )
  end

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body)   { fixture('projects/columns/columns.json') }
    let(:status) { 200 }

    it { expect(subject).to respond_to :all }

    it "fails to get resource without project_id" do
      expect { subject.list }.to raise_error(ArgumentError)
    end

    it "gets the resources" do
      subject.list project_id
      expect(a_get(request_path)).to have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list project_id }
    end

    it "gets project information" do
      columns = subject.list project_id
      expect(columns.first.name).to eq 'To Do'
    end

    it "yields to a block" do
      yielded = []
      result = subject.list(project_id) { |obj| yielded << obj }
      expect(yielded).to eq result
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.list project_id }
  end
end # list
