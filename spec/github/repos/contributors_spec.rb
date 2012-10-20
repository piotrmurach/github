# encoding: utf-8

require 'spec_helper'

describe Github::Repos, '#contributors' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }

  after { reset_authentication_for subject }

  let(:request_path) { "/repos/#{user}/#{repo}/contributors" }

  before do
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  end

  context "resource found" do
    let(:body)   { fixture('repos/contributors.json') }
    let(:status) { 200 }

    it "should raise error when no user/repo parameters" do
      expect {
        subject.contributors nil, repo
      }.to raise_error(ArgumentError, /\[user\] parameter cannot be nil/)
    end

    it "should raise error when no repository" do
      expect {
        subject.contributors user, nil
      }.to raise_error(ArgumentError, /\[repo\] parameter cannot be nil/)
    end

    it "should find resources" do
      subject.contributors user, repo
      a_get(request_path).should have_been_made
    end

    it "should return array of resources" do
      contributors = subject.contributors user, repo
      contributors.should be_an Array
      contributors.should have(1).items
    end

    it "should get branch information" do
      contributors = subject.contributors user, repo
      contributors.first.login.should == 'octocat'
    end

    it "should yield to a block" do
      subject.should_receive(:contributors).with(user, repo).and_yield('web')
      subject.contributors(user, repo) { |param| 'web'}
    end
  end

  context "resource not found" do
    let(:body)   { '' }
    let(:status) { 404 }

    it "should fail to get resource" do
      expect {
        subject.contributors user, repo
      }.to raise_error(Github::Error::NotFound)
    end
  end
end # contributors
