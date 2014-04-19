# encoding: utf-8

require 'spec_helper'

describe Github::Client::Issues::Labels, '#add' do
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/issues/#{issue_id}/labels" }

  before {
    stub_post(request_path).
      to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  let(:issue_id) { 1 }
  let(:label) { "Label 1" }

  context "labels added" do
    let(:body) { fixture('issues/labels.json') }
    let(:status) { 200 }

    it "should fail to add labels if issue-id is missing" do
      expect {
        subject.add user, repo, nil, label
      }.to raise_error(ArgumentError)
    end

    it "should create resource successfully" do
      subject.add user, repo, issue_id, label
      a_post(request_path).should have_been_made
    end

    it "should return the resource" do
      labels = subject.add user, repo, issue_id, label
      labels.first.should be_a Hashie::Mash
    end

    it "should get the label information" do
      labels = subject.add user, repo, issue_id, label
      labels.first.name.should == 'bug'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.add user, repo, issue_id, label }
  end
end # add
