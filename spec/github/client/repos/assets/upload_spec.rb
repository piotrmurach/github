# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Releases::Assets, '#upload' do
  let(:owner)    { 'peter-murach' }
  let(:repo)     { 'github' }
  let(:id)       { 1 }
  let(:filepath) { 'batman.js' }
  let(:file)     { double(:file, read: nil, close: nil) }
  let(:endpoint) { 'https://uploads.github.com' }
  let(:inputs)   { {name: 'batman.jpg', content_type: 'application/javascript'} }
  let(:path)     { "/repos/#{owner}/#{repo}/releases/#{id}/assets" }

  before {
    Faraday::UploadIO.stub(:new).and_return(file)
    stub_post(path, endpoint).with(query: {name:'batman.jpg'}).to_return(body: body, status: status,
      headers: {content_type: 'application/json; charset=utf-8'})
  }

  after { reset_authentication_for(subject) }

  context "resource edited successfully" do
    let(:body)   { fixture("repos/asset.json") }
    let(:status) { 201 }

    it { expect {subject.upload owner, repo }.to raise_error(ArgumentError) }

    it "should upload the resource" do
      subject.upload owner, repo, id, filepath, inputs
      expect(a_post(path, endpoint).with(query: {name:'batman.jpg'})).to have_been_made
    end

    it "should get the asset information back" do
      asset = subject.upload owner, repo, id, filepath, inputs
      expect(asset.id).to eq id
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.upload owner, repo, id, filepath, inputs }
  end
end # upload
