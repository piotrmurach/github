# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Github::Client::Projects::Columns, '#update' do
  let(:column_id)    { 367 }
  let(:request_path) { "/projects/columns/#{column_id}" }
  let(:body) { fixture("projects/columns/column.json") }
  let(:status) { 200 }
  let(:inputs) do
    { "name" => 'To Do' }
  end

  before do
    stub_patch(request_path).with(body: inputs).
      to_return(body: body, status: status,
                headers: { content_type: 'application/json; charset=utf-8' })
  end

  after { reset_authentication_for(subject) }

  it { expect(subject).to respond_to :edit }

  context "resource updated successfully" do
    it "fails to update without id parameter" do
      expect { subject.update }.to raise_error(ArgumentError)
    end

    it "updates the resource" do
      subject.update(column_id, inputs)
      expect(a_patch(request_path).with(body: inputs)).to have_been_made
    end

    it "returns resource" do
      column = subject.update column_id, inputs
      expect(column).to be_a Github::ResponseWrapper
    end

    it "retrieves information" do
      column = subject.update column_id, inputs
      expect(column.name).to eq('To Do')
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.update column_id, inputs }
  end
end # update
