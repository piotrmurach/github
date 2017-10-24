# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Statistics, '#code_frequency' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/stats/code_frequency" }

  before {
    stub_get(request_path).to_return(:body => body)
  }

  context "resource found" do
    let(:body) { fixture('repos/frequency.json') }
    let(:status) { 200 }

    it { expect { subject.code_frequency }.to raise_error(ArgumentError) }

    it "should get the resources" do
      subject.code_frequency user, repo
      a_get(request_path).should have_been_made
    end
  end
end
