# encoding: utf-8

require 'spec_helper'

describe Github::Client::GitData::Tags, '#get' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:sha) { "940bd336248efae0f9ee5bc7b2d5c985887b16ac" }
  let(:request_path) { "/repos/#{user}/#{repo}/git/tags/#{sha}" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  context "resource found" do
    let(:body) { fixture('git_data/tag.json') }
    let(:status) { 200 }

    it { should respond_to :find }

    it "should fail to get resource without sha" do
      expect { subject.get user, repo }.to raise_error(ArgumentError)
    end

    it "should get the resource" do
      subject.get user, repo, sha
      a_get(request_path).should have_been_made
    end

    it "should get tag information" do
      tag = subject.get user, repo, sha
      tag.tag.should eql "v0.0.1"
    end

    it "should return mash" do
      tag = subject.get user, repo, sha
      tag.should be_a Github::ResponseWrapper
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get user, repo, sha }
  end

end # get
