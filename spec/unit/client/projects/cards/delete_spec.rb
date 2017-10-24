# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Github::Client::Projects::Cards, '#delete' do
  let(:card_id) { 1478 }
  let(:request_path) { "/projects/columns/cards/#{card_id}" }
  let(:body) { '' }
  let(:status) { 204 }

  before do
    stub_delete(request_path).
      to_return(body: body, status: status,
                headers: { content_type: "application/json; charset=utf-8" })
  end

  after { reset_authentication_for subject }

  it { expect(subject).to respond_to :remove }

  it "deletes the resource successfully" do
    subject.delete card_id
    expect(a_delete(request_path)).to have_been_made
  end

  it "fails to delete resource without 'id' parameter" do
    expect { subject.delete }.to raise_error(ArgumentError)
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.delete card_id }
  end
end # delete
