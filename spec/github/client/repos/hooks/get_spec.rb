# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Hooks, '#get' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:hook_id) { 1 }
  let(:request_path) { "/repos/#{user}/#{repo}/hooks/#{hook_id}" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body)  { fixture('repos/hook.json') }
    let(:status) { 200 }

    it { subject.should respond_to :find }

    it "should fail to get resource without hook id" do
      expect { subject.get user, repo }.to raise_error(ArgumentError)
    end

    it "should get the resource" do
      subject.get user, repo, hook_id
      a_get(request_path).should have_been_made
    end

    it "should get hook information" do
      hook = subject.get user, repo, hook_id
      hook.id.should == hook_id
      hook.name.should == 'web'
    end

    it "should return mash" do
      hook = subject.get user, repo, hook_id
      hook.should be_a Github::ResponseWrapper
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get user, repo, hook_id }
  end
end # get
