# encoding: utf-8

require 'spec_helper'

describe Github::Client::Issues, '#get' do
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:issue_id) { 1347 }
  let(:request_path) { "/repos/#{user}/#{repo}/issues/#{issue_id}" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body) { fixture('issues/issue.json') }
    let(:status) { 200 }

    it { should respond_to :find }

    it "should fail to get resource without issue id" do
      expect { subject.get user, repo, nil }.to raise_error(ArgumentError)
    end

    it "should get the resource" do
      subject.get user, repo, issue_id
      a_get(request_path).should have_been_made
    end

    it "should get issue information" do
      issue = subject.get user, repo, issue_id
      issue.number.should == issue_id
      issue.title.should == 'Found a bug'
    end

    it "should return mash" do
      issue = subject.get user, repo, issue_id
      issue.should be_a Github::ResponseWrapper
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get user, repo, issue_id }
  end
end # get
