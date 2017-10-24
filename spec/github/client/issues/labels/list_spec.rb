# encoding: utf-8

require 'spec_helper'

describe Github::Client::Issues::Labels, '#list' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/labels" }
  let(:body) { fixture('issues/labels.json') }
  let(:status) { 200 }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "for this repository" do
    it { should respond_to :all }

    it { expect { subject.list }.to raise_error(ArgumentError) }

    it "should fail to get resource without username" do
      expect { subject.list user }.to raise_error(ArgumentError)
    end

    it "should get the resources" do
      subject.list user, repo
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list user, repo }
    end

    it "should get issue information" do
      labels = subject.list user, repo
      labels.first.name.should == 'bug'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list(user, repo) { |obj| yielded << obj }
      yielded.should == result
    end
  end

  context "for this milestone" do
    let(:milestone_id) { 1 }
    let(:request_path) { "/repos/#{user}/#{repo}/milestones/#{milestone_id}/labels"}
    let(:body) { fixture('issues/labels.json') }
    let(:status) { 200 }

    it "should get the resources" do
      subject.list user, repo, :milestone_id => milestone_id
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list user, repo, :milestone_id => milestone_id }
    end

    it "should get issue information" do
      labels = subject.list user, repo, :milestone_id => milestone_id
      labels.first.name.should == 'bug'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list(user, repo, :milestone_id => milestone_id) { |obj| yielded << obj }
      yielded.should == result
    end
  end

  context "resource found" do
    let(:issue_id) { 1 }
    let(:request_path) { "/repos/#{user}/#{repo}/issues/#{issue_id}/labels" }
    let(:body) { fixture('issues/labels.json') }
    let(:status) { 200 }

    it "should get the resources" do
      subject.list user, repo, :issue_id => issue_id
      a_get(request_path).should have_been_made
    end

    it "should get issue information" do
      labels = subject.list user, repo, :issue_id => issue_id
      labels.first.name.should == 'bug'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list(user, repo, :issue_id => issue_id) { |obj| yielded << obj }
      yielded.should == result
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.list user, repo }
  end
end # list
