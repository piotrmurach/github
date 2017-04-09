# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Error::UnprocessableEntity do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/pulls" }
  let(:inputs) do
    {
        "title" => "Amazing new feature",
        "body" => "Please pull this in!",
        "head" => "noexist",
        "base" => "master",
        "state" => "open"
    }
  end

  def test_request(body='')
    stub_post(request_path).with(body: inputs).
      to_return(body: body, status: 422, headers: {content_type: "application/json; charset=utf-8"})
  end

  it "handles multiple nested errors" do
    test_request "{\"message\":\"Validation Failed\",\"errors\":[{\"resource\":\"PullRequest\",\"code\":\"missing_field\",\"field\":\"head_sha\"},{\"resource\":\"PullRequest\",\"code\":\"missing_field\",\"field\":\"base_sha\"},{\"resource\":\"PullRequest\",\"code\":\"custom\",\"message\":\"No commits between master and noexist\"}],\"documentation_url\":\"https://developer.github.com/enterprise/2.6/v3/pulls/#create-a-pull-request\"}"

    expect {
      Github::Client::PullRequests.new.create(user, repo, inputs)
    }.to raise_error(Github::Error::UnprocessableEntity, /No commits between master and noexist/)
  end
end # Github::Error::UnprocessableEntity
