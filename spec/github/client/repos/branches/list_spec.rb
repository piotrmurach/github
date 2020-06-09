# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Branches, '#list' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/branches" }

  after { reset_authentication_for subject }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  context "resource found" do
    let(:body)   { fixture('repos/branches.json') }
    let(:status) { 200 }

    it "should raise error when no user/repo parameters" do
      expect { subject.list nil, repo }.to raise_error(ArgumentError)
    end

    it "should raise error when no repository" do
      expect { subject.list user, nil }.to raise_error(ArgumentError)
    end

    it "should find resources" do
      subject.list user, repo
      expect(a_get(request_path)).to have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list user, repo }
    end

    it "should get branch information" do
      branches = subject.list user, repo
      expect(branches.first.name).to eq 'master'
    end

    it "should yield to a block" do
      block = lambda { |el| repo }
      expect(subject).to receive(:list).with(user, repo).and_yield repo
      subject.list(user, repo, &block)
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.list user, repo }
  end
end # branches
