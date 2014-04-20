# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos, '#contributors' do
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
      expect { subject.contributors }.to raise_error(ArgumentError)
    end

    it "should raise error when no repository" do
      expect { subject.contributors user }.to raise_error(ArgumentError)
    end

    it 'filters out unknown parameters' do
      subject.contributors user, repo, :unknown => true
      a_get(request_path).with({}).should have_been_made
    end

    it "should find resources" do
      subject.contributors user, repo
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.contributors user, repo }
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

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.contributors user, repo }
  end
end # contributors
