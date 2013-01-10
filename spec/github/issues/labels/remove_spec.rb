# encoding: utf-8

require 'spec_helper'

describe Github::Issues::Labels, '#remove' do
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:issue_id) { 1 }
  let(:label_id) { 1 }
  let(:request_path) { "/repos/#{user}/#{repo}/issues/#{issue_id}/labels/#{label_id}" }

  before {
    stub_delete(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "remove a label from an issue" do
    let(:body) { fixture('issues/labels.json') }
    let(:status) { 200 }

    it "should throw exception if issue-id not present" do
      expect { subject.remove user, repo, nil }.to raise_error(ArgumentError)
    end

    it "should remove label successfully" do
      subject.remove user, repo, issue_id, :label_name => label_id
      a_delete(request_path).should have_been_made
    end

    it "should return the resource" do
      labels = subject.remove user, repo, issue_id, :label_name => label_id
      labels.first.should be_a Hashie::Mash
    end

    it "should get the label information" do
      labels = subject.remove user, repo, issue_id, :label_name => label_id
      labels.first.name.should == 'bug'
    end
  end

  context "remove all labels from an issue" do
    let(:request_path) { "/repos/#{user}/#{repo}/issues/#{issue_id}/labels" }
    let(:body) { '[]' }
    let(:status) { 204 }

    it "should remove labels successfully" do
      subject.remove user, repo, issue_id
      a_delete(request_path).should have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.remove user, repo, issue_id, :label_name => label_id }
  end

end # remove
