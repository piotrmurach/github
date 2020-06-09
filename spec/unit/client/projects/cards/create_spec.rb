# encoding: utf-8

require 'spec_helper'

describe Github::Client::Projects::Cards, '#create' do
  let(:column_id) { 367 }
  let(:inputs) do
    {
      note: 'Add payload for delete Project column',
      content_id: 3,
      content_type: 'Issue'
    }
  end

  before do
    subject.oauth_token = OAUTH_TOKEN
    stub_post(request_path).with(body: inputs).
      to_return(body: body, status: status,
                headers: { content_type: "application/json; charset=utf-8" })
  end

  after { reset_authentication_for subject }

  context "resource created successfully" do
    let(:body)   { fixture('projects/cards/card.json') }
    let(:status) { 201 }

    context "for the authenticated user" do
      let(:request_path) { "/projects/columns/#{column_id}/cards?access_token=#{OAUTH_TOKEN}" }

      it "creates resource" do
        subject.create column_id, inputs
        expect(a_post(request_path).with(body: inputs)).to have_been_made
      end

      it "returns the resource" do
        card = subject.create column_id, inputs
        expect(card.note).to eq 'Add payload for delete Project column'
      end

      it "returns mash type" do
        card = subject.create column_id, inputs
        expect(card).to be_a Github::ResponseWrapper
      end
    end
  end
end # create
