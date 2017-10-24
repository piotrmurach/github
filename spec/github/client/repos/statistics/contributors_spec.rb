# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Statistics, '#contributors' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/stats/contributors" }

  before {
    stub_get(request_path).to_return(:body => body)
  }

  context "resource found" do
    let(:body) { fixture('repos/contribs.json') }
    let(:status) { 200 }

    it { expect { subject.contributors }.to raise_error(ArgumentError) }

    it "should get the resources" do
      subject.contributors user, repo
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.contributors user, repo }
    end
  end
end
