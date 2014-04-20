# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Statistics, '#commit_activity' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/stats/commit_activity" }

  before {
    stub_get(request_path).to_return(:body => body)
  }

  context "resource found" do
    let(:body) { fixture('repos/commit_activity.json') }
    let(:status) { 200 }

    it { expect { subject.commit_activity }.to raise_error(ArgumentError) }

    it "should get the resources" do
      subject.commit_activity user, repo
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.commit_activity user, repo }
    end
  end
end
