# encoding: utf-8

require 'spec_helper'

describe Github::Activity::Watching, '#list' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/subscribers" }
  let(:body) { fixture("repos/watchers.json") }
  let(:status) { 200 }

  after { reset_authentication_for subject }

  before {
    stub_get(request_path).
      to_return(:body => body, :status => status, :headers => {})
  }

  it "should fail to get resource without username" do
    expect { subject.list }.to raise_error(ArgumentError)
  end

  it "should yield iterator if block given" do
    subject.should_receive(:list).with(user, repo).and_yield('github')
    subject.list(user, repo) { |param| 'github' }
  end

  it "should get the resources" do
    subject.list user, repo
    a_get(request_path).should have_been_made
  end

  it "should return array of resources" do
    watchers = subject.list user, repo
    watchers.should be_an Array
    watchers.should have(1).items
  end

  it "should return result of mash type" do
    watchers = subject.list user, repo
    watchers.first.should be_a Hashie::Mash
  end

  it "should get watcher information" do
    watchers = subject.list user, repo
    watchers.first.login.should == 'octocat'
  end

  context "fail to find resource" do
    let(:body)   { '' }
    let(:status) { 404 }

    it "should return 404 not found message" do
      expect {
        subject.list user, repo
      }.to raise_error(Github::Error::NotFound)
    end
  end
end # list
