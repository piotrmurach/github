# encoding: utf-8

require 'spec_helper'

describe Github::Client::Issues::Assignees, '#check' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:assignee) { 'octocat' }
  let(:request_path) { "/repos/#{user}/#{repo}/assignees/#{assignee}" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found " do
    let(:body) { '[]' }
    let(:status) { 204 }

    it "should fail to get resource without collaborator name" do
      expect { subject.check user, repo, nil }.to raise_error(ArgumentError)
    end

    it "should get the resource" do
      subject.check user, repo, assignee
      a_get(request_path).should have_been_made
    end

    it "should find assignee" do
      subject.should_receive(:check).with(user, repo, assignee) { true }
      subject.check user, repo, assignee
    end
  end

  context "resource not found" do
    let(:body) { '[]' }
    let(:status) { 404 }

    it "should fail to retrieve resource" do
      subject.should_receive(:check).with(user, repo, assignee) { false }
      subject.check user, repo, assignee
    end
  end
end # check
