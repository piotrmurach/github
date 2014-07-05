# encoding: utf-8

require 'spec_helper'

describe Github::Client::Issues::Labels, '#remove' do
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:number) { 1 }
  let(:label_name) { 1 }
  let(:request_path) { "/repos/#{user}/#{repo}/issues/#{number}/labels/#{label_name}" }

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
      subject.remove user, repo, number, :label_name => label_name
      a_delete(request_path).should have_been_made
    end

    it "should return the resource" do
      labels = subject.remove user, repo, number, :label_name => label_name
      labels.first.should be_a Hashie::Mash
    end

    it "should get the label information" do
      labels = subject.remove user, repo, number, :label_name => label_name
      labels.first.name.should == 'bug'
    end
  end

  context "remove all labels from an issue" do
    let(:request_path) { "/repos/#{user}/#{repo}/issues/#{number}/labels" }
    let(:body) { '[]' }
    let(:status) { 204 }

    it "should remove labels successfully" do
      subject.remove user, repo, number
      a_delete(request_path).should have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.remove user, repo, number, :label_name => label_name }
  end
end # remove
