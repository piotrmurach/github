# encoding: utf-8

require "spec_helper"

RSpec.describe Github::Client::PullRequests::Reviews, "#dismiss" do
  let(:user)          { "peter-murach" }
  let(:repo)          { "github" }
  let(:pr_number)     { 1 }
  let(:review_number) { 1 }

  let(:status)  { 200 }
  let(:message) { "Looks great" }
  let(:request_path) do
    "/repos/#{user}/#{repo}/pulls/#{pr_number}/reviews/#{review_number}/dismissals"
  end

  before do
    stub_put(request_path).to_return(
      body: { message: message }.to_json,
      status: status,
      headers: { content_type: "application/json; charset=utf-8" }
    )
  end

  after { reset_authentication_for(subject) }

  context "resource removed" do
    it "raises error if pull request number not present" do
      expect { subject.dismiss(user, repo) }.to raise_error(ArgumentError)
    end

    it "raises error if review number not present" do
      expect { subject.dismiss(user, repo, pr_number) }.to raise_error(ArgumentError)
    end

    it "removes resource successfully" do
      subject.dismiss user, repo, pr_number, review_number
      expect(a_put(request_path)).to have_been_made
    end
  end

  it_should_behave_like "request failure" do
    let(:requestable) { subject.dismiss(user, repo, pr_number, review_number) }
  end
end # dismiss
