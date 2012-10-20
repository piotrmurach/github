# encoding: utf-8

require 'spec_helper'

describe Github::Repos, '#branches' do
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
      expect { subject.branches nil, repo }.to raise_error(ArgumentError)
    end

    it "should raise error when no repository" do
      expect { subject.branches user, nil }.to raise_error(ArgumentError)
    end

    it "should find resources" do
      subject.branches user, repo
      a_get(request_path).should have_been_made
    end

    it "should return array of resources" do
      branches = subject.branches user, repo
      branches.should be_an Array
      branches.should have(1).items
    end

    it "should get branch information" do
      branches = subject.branches user, repo
      branches.first.name.should == 'master'
    end

    it "should yield to a block" do
      block = lambda { |el| repo }
      subject.should_receive(:branches).with(user, repo).and_yield repo
      subject.branches(user, repo, &block)
    end
  end

  context "resource not found" do
    let(:body)   { '' }
    let(:status) { 404 }

    it "should fail to get resource" do
      expect {
        subject.branches user, repo
      }.to raise_error(Github::Error::NotFound)
    end
  end
end # branches
