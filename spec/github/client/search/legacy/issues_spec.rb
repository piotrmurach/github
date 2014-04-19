# encoding: utf-8

require 'spec_helper'

describe Github::Client::Search::Legacy, '#issues' do
  let(:keyword)      { 'api' }
  let(:request_path) {"/legacy/issues/search/#{owner}/#{repo}/#{state}/#{keyword}"}
  let(:owner)        { 'peter-murach' }
  let(:repo)         { 'github' }
  let(:state)        { 'closed' }

  before do
    stub_get(request_path).
      to_return(body: body, status: status,
        headers: {content_type: "application/json; charset=utf-8"})
  end

  context "resource found" do
    let(:body)   { fixture('search/issues_legacy.json') }
    let(:status) { 200 }

    it { expect { subject.issues }.to raise_error(ArgumentError) }

    it "should get the resources" do
      subject.issues owner, repo, state, keyword
      a_get(request_path).should have_been_made
    end

    it "should get the resource through params hash" do
      subject.issues owner: owner, repo: repo, state: state, keyword: keyword
      a_get(request_path).should have_been_made
    end

    it "should get repository information" do
      issues = subject.issues owner: owner, repo: repo, state: state, keyword: keyword
      issues.issues.first.user.should == 'ckarbass'
    end
  end
end
