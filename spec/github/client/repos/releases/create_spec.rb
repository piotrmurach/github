# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Repos::Releases, '#create' do
  let(:owner)  { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:tag)    { 'v1.0.0' }
  let(:path )  { "/repos/#{owner}/#{repo}/releases" }

  before {
    stub_post(path).to_return(body: body, status: status,
      headers: {content_type: 'application/json; charset=utf-8'})
  }

  after { reset_authentication_for(subject) }

  context 'resource created' do
    let(:body)   { fixture('repos/release.json') }
    let(:status) { 201 }

    it 'fails to create resource without repo' do
      expect { subject.create owner }.to raise_error(ArgumentError)
    end

    it "failse to create resource without tag_name option" do
      expect {
        subject.create(owner, repo)
      }.to raise_error(Github::Error::RequiredParams,
                       /Required parameters are: tag_name/)
    end

    it "creates the resource" do
      subject.create(owner, repo, tag_name: 'v1.0.0')
      expect(a_post(path)).to have_been_made
    end

    it "gets the key information back" do
      release = subject.create(owner, repo, tag_name: 'v1.0.0')
      expect(release.tag_name).to eq(tag)
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create(owner, repo, tag_name:'v1.0.0') }
  end
end # create
