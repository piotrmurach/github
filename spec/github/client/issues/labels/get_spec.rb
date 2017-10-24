# encoding: utf-8

require 'spec_helper'

describe Github::Client::Issues::Labels, '#get' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:label_name) { 1 }
  let(:request_path) { "/repos/#{user}/#{repo}/labels/#{label_name}" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body) { fixture('issues/label.json') }
    let(:status) { 200 }

    it { should respond_to :get }

    it "should fail to get resource without label id" do
      expect { subject.get user, repo, nil }.to raise_error(ArgumentError)
    end

    it "should get the resource" do
      subject.get user, repo, label_name
      a_get(request_path).should have_been_made
    end

    it "should get label information" do
      label = subject.get user, repo, label_name
      label.name.should == 'bug'
    end

    it "should return mash" do
      label = subject.get user, repo, label_name
      label.should be_a Github::ResponseWrapper
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get user, repo, label_name }
  end
end # find
