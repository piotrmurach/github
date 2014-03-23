# encoding: utf-8

require 'spec_helper'

describe Github::Client::Activity::Watching, '#list' do
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

  it { expect { subject.list user }.to raise_error(ArgumentError) }

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

  it_should_behave_like 'an array of resources' do
    let(:requestable) { subject.list user, repo }
  end

  it "should get watcher information" do
    watchers = subject.list user, repo
    watchers.first.login.should == 'octocat'
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.list user, repo }
  end
end # list
