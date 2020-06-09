# encoding: utf-8

require 'spec_helper'

describe Github::Client::GitData::Trees, '#get' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:sha) { "9fb037999f264ba9a7fc6274d15fa3ae2ab98312" }
  let(:request_path) { "/repos/#{user}/#{repo}/git/trees/#{sha}" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  context "non-resursive" do
    let(:body) { fixture('git_data/tree.json') }
    let(:status) { 200 }

    it { is_expected.to respond_to :find }

    it "should fail to get resource without sha" do
      expect { subject.get user, repo }.to raise_error(ArgumentError)
    end

    it "should get the resource" do
      subject.get user, repo, sha
      expect(a_get(request_path)).to have_been_made
    end

    it "should get tree information" do
      tree = subject.get user, repo, sha
      expect(tree.sha).to eql sha
    end

    it "should return response wrapper" do
      tree = subject.get user, repo, sha
      expect(tree).to be_a Github::ResponseWrapper
    end
  end

  context "resursive" do
    let(:request_path) { "/repos/#{user}/#{repo}/git/trees/#{sha}?recursive=1" }
    let(:body) { fixture('git_data/tree.json') }
    let(:status) { 200 }

    it "should get the resource" do
      subject.get user, repo, sha, 'recursive' => true
      expect(a_get(request_path)).to have_been_made
    end

    it "should get tree information" do
      tree = subject.get user, repo, sha, 'recursive' => true
      expect(tree.sha).to eql sha
    end

    it "should return response wrapper" do
      tree = subject.get user, repo, sha, 'recursive' => true
      expect(tree).to be_a Github::ResponseWrapper
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get user, repo, sha }
  end

end # get
