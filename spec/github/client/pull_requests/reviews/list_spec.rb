# encoding: utf-8

require "spec_helper"

RSpec.describe Github::Client::PullRequests::Reviews, "#list" do
  let(:repo)   { "github" }
  let(:user)   { "peter-murach" }
  let(:number) { 1 }

  before do
    stub_get(request_path).to_return(
      body: body,
      status: status,
      headers: { content_type: "application/json; charset=utf-8" }
    )
  end

  after { reset_authentication_for(subject) }

  context "on a pull request" do
    let(:body)         { fixture("pull_requests/reviews.json") }
    let(:status)       { 200 }
    let(:request_path) do
      "/repos/#{user}/#{repo}/pulls/#{number}/reviews"
    end

    it { is_expected.to respond_to :all }

    it { expect { subject.list }.to raise_error(ArgumentError) }

    it "throws error if pull request number not provided" do
      expect { subject.list user, repo }.to raise_error(ArgumentError)
    end

    it "gets the resources" do
      subject.list user, repo, number
      expect(a_get(request_path)).to have_been_made
    end

    it_should_behave_like "an array of resources" do
      let(:requestable) { subject.list user, repo, number }
    end

    it "gets pull request review information" do
      reviews = subject.list user, repo, number
      expect(reviews.first.id).to eq(80)
    end

    it "yields to a block" do
      yielded = []
      result = subject.list(user, repo, number) { |obj| yielded << obj }
      expect(yielded).to eq(result)
    end
  end
end # list
