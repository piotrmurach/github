# encoding: utf-8

require 'spec_helper'

describe Github::Error::ServiceError, 'parse_body' do
  let(:message) { 'Requires authentication' }
  let(:body)    { "{\"message\":\"#{message}\"}" }
  let(:status)  { "401 Unauthorized" }
  let(:response_headers) { {"status"=>"401 Unauthorized"} }
  let(:response) {{
    body: body,
    status: status,
    response_headers: response_headers
  }}

  let(:object) { described_class.new(response) }

  subject { object.parse_body(body) }

  it "decodes body" do
    expect(object).to receive(:decode_body).with(body)
    subject
  end

  context 'when non string' do
    let(:body) { {message: message} }

    it "parses object" do
      expect(subject).to eql(message)
    end
  end

  context 'when string' do
    it "parses string" do
      expect(subject).to eql(message)
    end
  end
end # Github::Error::ServiceError
