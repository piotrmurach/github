# encoding: utf-8

require "spec_helper"

RSpec.describe Github::Client::PullRequests::Reviews, "#update" do
  let(:user)         { "peter-murach" }
  let(:repo)         { "github" }
  let(:pr_number)    { 1 }
  let(:number)       { 1 }
  let(:request_path) do
    "/repos/#{user}/#{repo}/pulls/#{pr_number}/reviews/#{number}/events"
  end
  let(:inputs) do
    {
      "body"  => "Nice change",
      "event" => "APPROVE"
    }
  end

  before do
    stub_post(request_path).with(body: inputs).to_return(
      body: body,
      status: status,
      headers: { content_type: "application/json; charset=utf-8" }
    )
  end

  after { reset_authentication_for(subject) }

  context "resouce updated" do
    let(:body)   { fixture("pull_requests/review.json") }
    let(:status) { 200 }

    it { expect { subject.update }.to raise_error(ArgumentError) }

    it "updates resource successfully" do
      subject.update(user, repo, pr_number, number, inputs)
      expect(a_post(request_path).with(body: inputs)).to have_been_made
    end

    it "returns the resource" do
      review = subject.update(user, repo, pr_number, number, inputs)
      expect(review).to be_a(Github::ResponseWrapper)
    end

    it "should get the review information" do
      review = subject.update(user, repo, pr_number, number, inputs)
      expect(review.user.login).to eq("octocat")
    end
  end

  it_should_behave_like "request failure" do
    let(:requestable) { subject.update(user, repo, pr_number, number, inputs) }
  end
end # update
