# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Releases, '#edit' do
  let(:owner)  { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:id)     { 1 }
  let(:path)   { "/repos/#{owner}/#{repo}/releases/#{id}" }
  let(:inputs) { {'name' => 'v1.0.0', 'body' => 'New release'} }

  before {
    stub_patch(path).with(inputs).to_return(body: body, status: status,
      headers: {content_type: 'application/json; charset=utf-8'})
  }

  after { reset_authentication_for(subject) }

  context "resource edited successfully" do
    let(:body)   { fixture("repos/release.json") }
    let(:status) { 200 }

    it { expect {subject.edit owner, repo }.to raise_error(ArgumentError) }

    it "should edit the resource" do
      subject.edit owner, repo, id, inputs
      expect(a_patch(path)).to have_been_made
    end

    it "should get the key information back" do
      release = subject.edit owner, repo, id, inputs
      expect(release.id).to eq id
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.edit owner, repo, id, inputs }
  end
end # edit
