# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Github::Client::Projects::Columns, '#move' do
  let(:column_id) { 367 }
  let(:request_path) { "/projects/columns/#{column_id}/moves" }
  let(:body) { '' }
  let(:status) { 204 }
  let(:inputs) do
    {
      position: "after:3"
    }
  end

  before do
    stub_post(request_path).with(body: inputs.to_json).
      to_return(body: body, status: status,
                headers: { content_type: "application/json; charset=utf-8" })
  end

  after { reset_authentication_for subject }

  it "moves the resource successfully" do
    subject.move column_id, inputs
    expect(a_post(request_path)).to have_been_made
  end

  it "fails to move resource without 'id' parameter" do
    expect { subject.move inputs }.to raise_error(ArgumentError)
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.move column_id, inputs }
  end
end # move
