# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Releases::Assets, '#get' do
  let(:owner) { 'peter-murach' }
  let(:repo)  { 'github' }
  let(:id)    { 1 }
  let(:path)  { "/repos/#{owner}/#{repo}/releases/assets/#{id}" }

  before {
    stub_get(path).to_return(body: body, status: status,
      headers: {content_type: 'application/json; charset=utf-8'})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body)   { fixture("repos/release.json") }
    let(:status) { 200 }

    it { is_expected.to respond_to :find }

    it { expect { subject.get }.to raise_error(ArgumentError) }

    it "should fail to get resource without id" do
      expect { subject.get owner, repo }.to raise_error(ArgumentError)
    end

    it "should get the resource" do
      subject.get owner, repo, id
      expect(a_get(path)).to have_been_made
    end

    it "should get key information" do
      asset = subject.get owner, repo, id
      expect(asset.id).to eq id
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get owner, repo, id }
  end
end # get
