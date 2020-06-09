# encoding: utf-8

require 'spec_helper'

describe Github::Client::GitData::References, '#update' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:ref) { "heads/master" }
  let(:request_path) { "/repos/#{user}/#{repo}/git/refs/#{ref}" }
  let(:inputs) {
    {
      "sha" => "827efc6d56897b048c772eb4087f854f46256132",
      "force" => true
    }
  }

  before {
    stub_patch(request_path).with(body: inputs).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce updated" do
    let(:body) { fixture('git_data/reference.json') }
    let(:status) { 201 }

    it "should fail to update resource if 'sha' input is missing" do
      expect {
        subject.update user, repo, ref, inputs.except('sha')
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should fail to update resource if 'ref' is wrong" do
      expect {
        subject.update user, repo, nil, inputs
      }.to raise_error(ArgumentError)
    end

    it "should update resource successfully" do
      subject.update user, repo, ref, inputs
      expect(a_patch(request_path).with(body: inputs)).to have_been_made
    end

    it "should return the resource" do
      reference = subject.update user, repo, ref, inputs
      expect(reference.first).to be_a Github::Mash
    end

    it "should get the reference information" do
      reference = subject.update user, repo, ref, inputs
      expect(reference.first.ref).to eql 'refs/heads/sc/featureA'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.update user, repo, ref, inputs }
  end

end # update
