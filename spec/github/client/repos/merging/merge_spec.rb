# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Merging, '#merge' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/merges" }
  let(:inputs) do
    {
      "base" => "master",
      "head" => "cool_feature",
      "commit_message" => "Shipped cool_feature!"
    }
  end

  before {
    stub_post(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce merged" do
    let(:body) { fixture('repos/merge.json') }
    let(:status) { 201 }

    it "should fail to merge resource if 'base' input is missing" do
      expect {
        subject.merge user, repo, inputs.except('base')
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should fail to create resource if 'head' input is missing" do
      expect {
        subject.merge user, repo, inputs.except('head')
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should merge resource successfully" do
      subject.merge user, repo, inputs
      a_post(request_path).with(inputs).should have_been_made
    end

    it "should return the resource" do
      merge = subject.merge user, repo, inputs
      merge.should be_a Github::ResponseWrapper
    end

    it "should get the commit comment information" do
      merge = subject.merge user, repo, inputs
      merge.commit.author.login.should == 'octocat'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.merge user, repo, inputs }
  end
end # merge
