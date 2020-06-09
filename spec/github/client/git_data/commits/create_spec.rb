# encoding: utf-8

require 'spec_helper'

describe Github::Client::GitData::Commits, '#get' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/git/commits" }
  let(:inputs) {
    {
      "message" =>  "my commit message",
      "author" =>  {
        "name" =>  "Scott Chacon",
        "email" => "schacon@gmail.com",
        "date" => "2008-07-09T16:13:30+12:00"
        },
      "parents" => [
        "7d1b31e74ee336d15cbd21741bc88a537ed063a0"
      ],
      "tree" => "827efc6d56897b048c772eb4087f854f46256132"
    }
  }

  before {
    stub_post(request_path).with(body: inputs).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  context "resouce created" do
    let(:body) { fixture('git_data/commit.json') }
    let(:status) { 201 }

    it { expect { subject.create user }.to raise_error(ArgumentError)}

    it "should fail to create resource if 'message' input is missing" do
      expect {
        subject.create user, repo, inputs.except('message')
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should fail to create resource if 'tree' input is missing" do
      expect {
        subject.create user, repo, inputs.except('tree')
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should fail to create resource if 'parents' input is missing" do
      expect {
        subject.create user, repo, inputs.except('parents')
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should create resource successfully" do
      subject.create user, repo, inputs
      expect(a_post(request_path).with(body: inputs)).to have_been_made
    end

    it "should return the resource" do
      commit = subject.create user, repo, inputs
      expect(commit).to be_a Github::ResponseWrapper
    end

    it "should get the commit information" do
      commit = subject.create user, repo, inputs
      expect(commit.author.name).to eql "Scott Chacon"
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create user, repo, inputs }
  end

end # create
