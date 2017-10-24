# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Commits, '#get' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:sha) { '23432dfosfsufd' }
  let(:request_path) { "/repos/#{user}/#{repo}/commits/#{sha}" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body)   { fixture('repos/commit.json') }
    let(:status) { 200 }

    it { should respond_to :find }

    it { expect { subject.get }.to raise_error(ArgumentError) }

    it "should fail to get resource without sha key" do
      expect { subject.get user, repo }.to raise_error(ArgumentError)
    end

    it "should get the resource" do
      subject.get user, repo, sha
      a_get(request_path).should have_been_made
    end

    it "should get commit information" do
      commit = subject.get user, repo, sha
      commit.commit.author.name.should == 'Monalisa Octocat'
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
