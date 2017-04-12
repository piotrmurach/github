# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Github::Client::Projects::Cards, '#list' do
  let(:column_id) { 367 }
  let(:request_path) { "/projects/columns/#{column_id}/cards" }

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
    let(:body)   { fixture('projects/cards/cards.json') }
    let(:status) { 200 }

    it { expect(subject).to respond_to :all }

    it "should fail to get resource without column_id" do
      expect { subject.list }.to raise_error(ArgumentError)
    end

    it "should get the resources" do
      subject.list column_id
      expect(a_get(request_path)).to have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list column_id }
    end

    it "should get project information" do
      cards = subject.list column_id
      expect(cards.first.note).to eq 'Add payload for delete Project column'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list(column_id) { |obj| yielded << obj }
      expect(yielded).to eq result
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.list column_id }
  end
end # list
