# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Github::Client::Projects::Cards, '#get' do
  let(:card_id) { 1478 }
  let(:request_path) { "/projects/columns/cards/#{card_id}" }
  let(:body) { fixture('projects/cards/card.json') }
  let(:status) { 200 }

  before do
    stub_get(request_path).
      to_return(body: body, status: status,
                headers: { content_type: "application/json; charset=utf-8" })
  end

  after { reset_authentication_for(subject) }

  context "resource found" do
    it "fails to get resource without project id" do
      expect { subject.get }.to raise_error(ArgumentError)
    end

    it "gets the resource" do
      subject.get(card_id)
      expect(a_get(request_path)).to have_been_made
    end

    it "gets project information" do
      card = subject.get card_id
      expect(card.id).to eq card_id
      expect(card.note).to eq('Add payload for delete Project column')
    end

    it "returns response wrapper" do
      card = subject.get card_id
      expect(card).to be_a Github::ResponseWrapper
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get card_id }
  end
end # get
