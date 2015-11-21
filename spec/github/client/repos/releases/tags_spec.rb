# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Releases::Tags, '#get' do
  let(:owner) { 'anuja-joshi' }
  let(:repo)  { 'rails_express' }
  let(:tag)    { 'v1' }
  let(:path)  { "/repos/#{owner}/#{repo}/releases/tags/#{tag}" }

  before {
    stub_get(path).to_return(body: body, status: status,
      headers: {content_type: 'application/json; charset=utf-8'})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body)   { fixture("repos/releases/tags.json") }
    let(:status) { 200 }

    it { expect { subject.get }.to raise_error(ArgumentError) }

    it "should fail to get resource without params" do
      expect { subject.get owner }.to raise_error(ArgumentError)
    end

    it "should get the resource" do
      subject.get owner, repo, tag
      expect(a_get(path)).to have_been_made
    end

    it "should get tag_name information" do
      release = subject.get owner, repo, tag
      expect(release.tag_name).to eq tag
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get owner, repo, tag }
  end
end # get
