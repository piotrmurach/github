# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Releases::Assets, '#edit' do
  let(:owner)  { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:id)     { 1 }
  let(:path)   { "/repos/#{owner}/#{repo}/releases/assets/#{id}" }
  let(:inputs) { {'name' => 'readme', 'label' => 'New readme'} }

  before {
    stub_patch(path).with(inputs).to_return(body: body, status: status,
      headers: {content_type: 'application/json; charset=utf-8'})
  }

  after { reset_authentication_for(subject) }

  context "resource edited successfully" do
    let(:body)   { fixture("repos/asset.json") }
    let(:status) { 200 }

    it { expect {subject.edit owner, repo }.to raise_error(ArgumentError) }

    it "should edit the resource" do
      subject.edit owner, repo, id, inputs
      expect(a_patch(path)).to have_been_made
    end

    it "should get the asset information back" do
      asset = subject.edit owner, repo, id, inputs
      expect(asset.id).to eq id
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.edit owner, repo, id, inputs }
  end

end # edit
