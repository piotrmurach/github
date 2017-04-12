# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Github::Client::Projects::Cards, '#update' do
  let(:card_id)    { 1478 }
  let(:request_path) { "/projects/columns/cards/#{card_id}" }
  let(:body) { fixture("projects/cards/card.json") }
  let(:status) { 200 }
  let(:inputs) do
    {
      "note" => 'Add payload for delete Project column'
    }
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
      subject.update(card_id, inputs)
      expect(a_patch(request_path).with(body: inputs)).to have_been_made
    end

    it "returns resource" do
      card = subject.update card_id, inputs
      expect(card).to be_a Github::ResponseWrapper
    end

    it "retrieves information" do
      card = subject.update card_id, inputs
      expect(card.note).to eq('Add payload for delete Project column')
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.update card_id, inputs }
  end
end # update
