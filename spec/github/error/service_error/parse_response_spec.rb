# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Error::ServiceError, '#new' do
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

  it "parses body" do
    error = described_class.new(response)

    expect(error.body).to eq(message)
  end

  it "parses http headers" do
    error = described_class.new(response)

    expect(error.http_headers).to eq(response_headers)
  end

  it "parses status" do
    error = described_class.new(response)

    expect(error.status).to eq(status)
  end

  it "assembles error message" do
    error = described_class.new(response)

    expect(error.message).to eql(" #{url}: #{status} #{message}")
  end
end # Github::Error::ServiceError
