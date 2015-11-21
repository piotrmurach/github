# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Releases, '#latest' do
  let(:owner) { 'peter-murach' }
  let(:repo)  { 'github' }
  let(:path)  { "/repos/#{owner}/#{repo}/releases/latest" }

  before {
    stub_get(path).to_return(body: body, status: status,
      headers: {content_type: 'application/json; charset=utf-8'})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body)   { fixture("repos/release.json") }
    let(:status) { 200 }
    let(:id) { 1 }

    it "should fail to get latest resource without 'user/repo' parameters" do
      expect { subject.latest }.to raise_error(ArgumentError)
    end

    it "should get the latest resource" do
      subject.latest owner, repo
      expect(a_get(path)).to have_been_made
    end
    
    it "should get the key information of latest resource" do
      release = subject.latest owner, repo
      expect(release.id).to eq id
    end

  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.latest owner, repo}
  end
end # latest
