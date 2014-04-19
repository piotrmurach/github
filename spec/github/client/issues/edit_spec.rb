# encoding: utf-8

require 'spec_helper'

describe Github::Client::Issues, '#edit' do
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:issue_id) { 1347 }
  let(:request_path) { "/repos/#{user}/#{repo}/issues/#{issue_id}" }
  let(:inputs) {
    {
        "title" =>  "Found a bug",
        "body" => "I'm having a problem with this.",
        "assignee" =>  "octocat",
        "milestone" => 1,
        "labels" => [
          "Label1",
          "Label2"
        ]
    }
  }

  before {
    stub_patch(request_path).with(inputs).
      to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource edited successfully" do
    let(:body) { fixture("issues/issue.json") }
    let(:status) { 200 }

    it "should fail to edit without 'user/repo' parameters" do
      expect {
        subject.edit nil, repo, issue_id
      }.to raise_error(ArgumentError)
    end

    it "should edit the resource" do
      subject.edit user, repo, issue_id, inputs
      a_patch(request_path).with(inputs).should have_been_made
    end

    it "should return resource" do
      issue = subject.edit user, repo, issue_id, inputs
      issue.should be_a Github::ResponseWrapper
    end

    it "should be able to retrieve information" do
      issue = subject.edit user, repo, issue_id, inputs
      issue.title.should == 'Found a bug'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.edit user, repo, issue_id, inputs }
  end

end # edit
