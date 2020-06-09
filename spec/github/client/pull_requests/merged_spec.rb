# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::PullRequests, '#merged?' do
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:number) { 1347 }
  let(:request_path) { "/repos/#{user}/#{repo}/pulls/#{number}/merge" }

  before { reset_authentication_for(subject) }
  after  { reset_authentication_for(subject) }

  context "checks whetehr pull request has been merged" do
    before {
      stub_get(request_path).to_return(body: "[]", status: 404,
        headers: {user_agent: subject.user_agent})
    }

    it { expect { subject.merged? }.to raise_error(ArgumentError) }

    it "fails validation " do
      expect { subject.merged?(user, repo) }.to raise_error(ArgumentError)
    end

    it "returns false if resource not found" do
      merged = subject.merged?(user, repo, number)
      expect(merged).to be false
    end

    it "returns true if resoure found" do
      stub_get(request_path).to_return(body: "[]", status: 200,
        headers: {user_agent: subject.user_agent})
      merged = subject.merged? user, repo, number
      expect(merged).to be true
    end
  end
end # merged?
