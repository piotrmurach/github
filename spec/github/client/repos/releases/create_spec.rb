# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Releases, '#create' do
  let(:owner)  { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:tag)    { 'v1.0.0' }
  let(:path )  { "/repos/#{owner}/#{repo}/releases" }
  let(:inputs) { {'name' => 'v1.0.0', 'body' => 'New release'} }

  before {
    stub_post(path).with(inputs).to_return(body: body, status: status,
      headers: {content_type: 'application/json; charset=utf-8'})
  }

  after { reset_authentication_for(subject) }

  context 'resource created' do
    let(:body)   { fixture('repos/release.json') }
    let(:status) { 201 }

    it 'should fail to create resource without tag name' do
      expect {
        subject.create owner, repo
      }.to raise_error(ArgumentError)
    end

    it "should create the resource" do
      subject.create owner, repo, tag, inputs
      expect(a_post(path).with(inputs)).to have_been_made
    end

    it "should get the key information back" do
      release = subject.create owner, repo, tag, inputs
      expect(release.tag_name).to eq tag
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create owner, repo, tag, inputs }
  end
end # create
