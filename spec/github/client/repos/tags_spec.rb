# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos, '#tags' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/tags" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  context "resource found" do
    let(:body) { fixture('repos/tags.json') }
    let(:status) { 200 }

    it "should raise error when no user/repo parameters" do
      expect { subject.tags nil, repo }.to raise_error(ArgumentError)
    end

    it "should raise error when no repository" do
      expect { subject.tags user, nil }.to raise_error(ArgumentError)
    end

    it "should find resources" do
      subject.tags user, repo
      a_get(request_path).should have_been_made
    end

    it "should return array of resources" do
      tags = subject.tags user, repo
      tags.should be_an Enumerable
      tags.should have(1).items
    end

    it "should get tag information" do
      tags = subject.tags user, repo
      tags.first.name.should == 'v0.1'
    end

    it "should yield to a block" do
      subject.should_receive(:tags).with(user, repo).and_yield('web')
      subject.tags(user, repo) { |param| 'web'}
    end
  end

  context "resource not found" do
    let(:body)   { '' }
    let(:status) { 404 }

    it "should fail to get resource" do
      expect { subject.tags user, repo }.to raise_error(Github::Error::NotFound)
    end
  end
end # tags
