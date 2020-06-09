# encoding: utf-8

require 'spec_helper'

describe Github::Client::Issues::Assignees, '#add' do
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/issues/#{issue_id}/assignees" }

  before {
    stub_post(request_path).
      to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  let(:issue_id) { 1 }
  let(:assignee) { "octocat" }

  context "assignees added" do
    let(:body) { fixture('issues/assignees.json') }
    let(:status) { 200 }

    it "should fail to add assignees if issue-id is missing" do
      expect {
        subject.add user, repo, nil, assignee
      }.to raise_error(ArgumentError)
    end

    it "should create resource successfully" do
      subject.add user, repo, issue_id, assignee
      expect(a_post(request_path)).to have_been_made
    end

    it "should return the resource" do
      issue = subject.add user, repo, issue_id, assignee
      expect(issue.assignees.first).to be_a Github::Mash
    end

    it "should get the assignee information" do
      issue = subject.add user, repo, issue_id, assignee
      expect(issue.assignees.first.login).to eq 'octocat'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.add user, repo, issue_id, assignee }
  end
end # add
