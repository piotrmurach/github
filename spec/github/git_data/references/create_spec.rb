# encoding: utf-8

require 'spec_helper'

describe Github::Client::GitData::References, '#create' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/git/refs" }
  let(:inputs) {
    {
      "ref" => "refs/heads/master",
      "sha" => "827efc6d56897b048c772eb4087f854f46256132",
      "unrelated" => 'giberrish'
    }
  }

  before {
    stub_post(request_path).with(inputs.except('unrelated')).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce created" do
    let(:body) { fixture('git_data/reference.json') }
    let(:status) { 201 }

    it "should fail to create resource if 'ref' input is missing" do
      expect {
        subject.create user, repo, inputs.except('ref')
      }.to raise_error(Github::Error::RequiredParams )
    end

    it "should fail to create resource if 'sha' input is missing" do
      expect {
        subject.create user, repo, inputs.except('sha')
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should fail to create resource if 'ref' is correct" do
      expect {
        subject.create user, repo, :ref => '/heads/master', :sha => '13t2a1r3'
      }.not_to raise_error()
    end

    it "should create resource successfully" do
      subject.create user, repo, inputs
      a_post(request_path).with(inputs).should have_been_made
    end

    it "should return the resource" do
      reference = subject.create user, repo, inputs
      reference.first.should be_a Hashie::Mash
    end

    it "should get the reference information" do
      reference = subject.create user, repo, inputs
      reference.first.ref.should eql 'refs/heads/sc/featureA'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create user, repo, inputs }
  end

end # create
