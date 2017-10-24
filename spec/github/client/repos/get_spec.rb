# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos, '#get' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  context "resource found" do
    let(:body)   { fixture('repos/repo.json') }
    let(:status) { 200 }

    it { should respond_to(:find) }

    it "should raise error when no user/repo parameters" do
      expect { subject.get nil, repo }.to raise_error(ArgumentError)
    end

    it "should raise error when no repository" do
      expect { subject.get user, nil }.to raise_error(ArgumentError)
    end

    it "should find resources" do
      subject.get user, repo
      a_get(request_path).should have_been_made
    end

    it "should return repository mash" do
      repository = subject.get user, repo
      repository.should be_a Github::ResponseWrapper
    end

    it "should get repository information" do
      repository = subject.get user, repo
      repository.name.should == 'Hello-World'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get user, repo }
  end
end # get
