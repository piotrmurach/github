# encoding: utf-8

require 'spec_helper'

describe Github::Error::ServiceError, 'parse_response' do
  let(:message) { 'Requires authentication' }
  let(:url)     { 'https://api.github.com/user/repos' }
  let(:body)    { "{\"message\":\"#{message}\"}" }
  let(:status)  { "401 Unauthorized" }
  let(:response_headers) { {"status"=>"401 Unauthorized"} }
  let(:response) {{
    body: body,
    status: status,
    response_headers: response_headers,
    url: url
  }}

  let(:object) { described_class.new(response) }

  subject { object.parse_response(response) }

  it "parses body" do
    expect(object).to receive(:parse_body).with(body)
    subject
  end

  it "parses http headers" do
    expect(object.http_headers).to eql(response_headers)
  end

  it "parses status" do
    expect(object.status).to eql(status)
  end

  it "assembles error message" do
    expect(subject).to eql(" #{url}: #{status} #{message}")
  end
end # Github::Error::ServiceError
