# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Error::ServiceError, '#new' do
  let(:url)     { 'https://api.github.com/user/repos' }
  let(:status)  { "401 Unauthorized" }
  let(:message) { 'Requires authentication' }
  let(:response_headers) { {content_type: "application/json; charset=utf-8"} }

  def create_response(body)
    {
      body: body,
      status: status,
      response_headers: response_headers,
      url: url,
      method: 'POST'
    }
  end

  it "creates message without errors summary" do
    body = "{\"message\":\"#{message}\"}"
    response = create_response(body)

    error = described_class.new(response)

    expect(error.to_s).to eq("POST #{url}: #{status} - Requires authentication")
  end

  it "creates message with single error summary" do
    body = "{\"message\":\"Validation Failed\",\"error\":\"No commits between master and noexist\", \"documentation_url\":\"https://developer.github.com/enterprise/2.6/v3/pulls/#create-a-pull-request\"}"
    response = create_response(body)

    error = described_class.new(response)

    expect(error.to_s).to eq([
      "POST #{url}: #{status} - Validation Failed",
      "Error: No commits between master and noexist",
      "See: https://developer.github.com/enterprise/2.6/v3/pulls/#create-a-pull-request"
    ].join("\n"))
  end

  it "creates message with multiple errors summary" do
    body = "{\"message\":\"Validation Failed\",\"errors\":[{\"resource\":\"PullRequest\",\"code\":\"missing_field\",\"field\":\"head_sha\"},{\"resource\":\"PullRequest\",\"code\":\"missing_field\",\"field\":\"base_sha\"},{\"resource\":\"PullRequest\",\"code\":\"custom\",\"message\":\"No commits between master and noexist\"}],\"documentation_url\":\"https://developer.github.com/enterprise/2.6/v3/pulls/#create-a-pull-request\"}"
    response = create_response(body)

    error = described_class.new(response)

    expect(error.to_s).to eq([
      "POST #{url}: #{status} - Validation Failed",
      "Errors:",
      "Error: resource: PullRequest, code: missing_field, field: head_sha",
      "Error: resource: PullRequest, code: missing_field, field: base_sha",
      "Error: resource: PullRequest, code: custom, message: No commits between master and noexist",
      "See: https://developer.github.com/enterprise/2.6/v3/pulls/#create-a-pull-request"
    ].join("\n"))
  end
end # Github::Error::ServiceError
