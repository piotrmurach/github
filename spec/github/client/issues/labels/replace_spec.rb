# encoding: utf-8

require 'spec_helper'

describe Github::Client::Issues::Labels, '#replace' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:number) { 1 }
  let(:label) { "Label 1" }
  let(:request_path) { "/repos/#{user}/#{repo}/issues/#{number}/labels" }

  before {
    stub_put(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "labels replaced" do
    let(:body) { fixture('issues/labels.json') }
    let(:status) { 200 }

    it "should fail to add labels if issue-id is missing" do
      expect {
        subject.replace user, repo, nil, label
      }.to raise_error(ArgumentError)
    end

    it "should create resource successfully" do
      subject.replace user, repo, number, label
      a_put(request_path).should have_been_made
    end

    it "should return the resource" do
      labels = subject.replace user, repo, number, label
      labels.first.should be_a Hashie::Mash
    end

    it "should get the label information" do
      labels = subject.replace user, repo, number, label
      labels.first.name.should == 'bug'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.replace user, repo, number, label }
  end
end # replace
