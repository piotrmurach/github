# frozen_string_literal: true

require 'spec_helper'

describe Github::Client::Projects::Cards, '#move' do
  let(:card_id) { 1478 }
  let(:request_path) { "/projects/columns/cards/#{card_id}/moves" }
  let(:body) { '' }
  let(:status) { 204 }
  let(:inputs) do
    {
      position: "after:3"
    }
  end

  before do
    stub_post(request_path).with(body: inputs.to_json).to_return(body: body, status: status,
                                                                 headers: { content_type: "application/json; charset=utf-8" })
  end

  after { reset_authentication_for subject }

  it "should move the resource successfully" do
    subject.move card_id, inputs
    expect(a_post(request_path)).to have_been_made
  end

  it "should fail to move resource without 'id' parameter" do
    expect { subject.move inputs }.to raise_error(ArgumentError)
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.move card_id, inputs }
  end
end # move
