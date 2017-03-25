# encoding: utf-8

require "spec_helper"

RSpec.describe Github::Client::PullRequests::Reviews, "#get" do
  let(:user)         { "peter-murach" }
  let(:repo)         { "github" }
  let(:number)       { 1 }
  let(:id)           { 80 }
  let(:request_path) do
    "/repos/#{user}/#{repo}/pulls/#{number}/reviews/#{id}"
  end

  before do
    stub_get(request_path).to_return(
      body: body,
      status: status,
      headers: { content_type: "application/json; charset=utf-8" }
    )
  end

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body)   { fixture("pull_requests/review.json") }
    let(:status) { 200 }

    it { should respond_to :find }

    it { expect { subject.get }.to raise_error(ArgumentError) }

    it "fails to get resource without pull request number" do
      expect { subject.get user, repo }.to raise_error(ArgumentError)
    end

    it "fails to get resource without review id" do
      expect { subject.get user, repo, number }.to raise_error(ArgumentError)
    end

    it "gets the resource" do
      subject.get user, repo, number, id
      expect(a_get(request_path)).to have_been_made
    end

    it "gets review information" do
      review = subject.get user, repo, number, id
      expect(review.id).to eq id
      expect(review.user.login).to eq("octocat")
    end

    it "returns response wrapper" do
      review = subject.get user, repo, number, id
      expect(review).to be_a(Github::ResponseWrapper)
    end
  end

  it_should_behave_like "request failure" do
    let(:requestable) { subject.get user, repo, number, id }
  end
end # get
