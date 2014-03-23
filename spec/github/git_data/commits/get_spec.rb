# encoding: utf-8

require 'spec_helper'

describe Github::Client::GitData::Commits, '#get' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:sha) { "3a0f86fb8db8eea7ccbb9a95f325ddbedfb25e15" }
  let(:request_path) { "/repos/#{user}/#{repo}/git/commits/#{sha}" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  context "resource found" do
    let(:body) { fixture('git_data/commit.json') }
    let(:status) { 200 }

    it { should respond_to :find }

    it { expect { subject.get }.to raise_error(ArgumentError) }

    it "should fail to get resource without sha" do
      expect { subject.get user, repo }.to raise_error(ArgumentError)
    end

    it "should get the resource" do
      subject.get user, repo, sha
      a_get(request_path).should have_been_made
    end

    it "should get commit information" do
      commit = subject.get user, repo, sha
      commit.author.name.should eql "Scott Chacon"
    end

    it "should return mash" do
      commit = subject.get user, repo, sha
      commit.should be_a Github::ResponseWrapper
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get user, repo, sha }
  end

end # get
