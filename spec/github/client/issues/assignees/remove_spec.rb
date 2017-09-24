# encoding: utf-8

require 'spec_helper'

describe Github::Client::Issues::Assignees, '#remove' do
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/issues/#{issue_id}/assignees" }

  before {
    stub_delete(request_path).
      to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  let(:issue_id) { 1 }
  let(:assignee) { "octocat" }

  context "assignees removed" do
    let(:body) { fixture('issues/assignees.json') }
    let(:status) { 200 }

    it "should fail to remove assignees if issue-id is missing" do
      expect {
        subject.remove user, repo, nil, assignee
      }.to raise_error(ArgumentError)
    end

    it "should remove resource successfully" do
      subject.remove user, repo, issue_id, assignee
      a_delete(request_path).should have_been_made
    end

    it "should return the resource" do
      issue = subject.remove user, repo, issue_id, assignee
      issue.assignees.first.should be_a Github::Mash
    end

    it "should get the assignee information" do
      issue = subject.remove user, repo, issue_id, assignee
      issue.assignees.first.login.should == 'octocat'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.remove user, repo, issue_id, assignee }
  end
end # remove
