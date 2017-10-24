# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos, '#languages' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/languages" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  context "resource found" do
    let(:body)   { fixture('repos/languages.json') }
    let(:status) { 200 }

    it "should raise error when no user/repo parameters" do
      expect { subject.languages nil, repo }.to raise_error(ArgumentError)
    end

    it "should raise error when no repository" do
      expect { subject.languages user, nil }.to raise_error(ArgumentError)
    end

    it "should find resources" do
      subject.languages user, repo
      a_get(request_path).should have_been_made
    end

    it "should return hash of languages" do
      languages = subject.languages user, repo
      languages.should be_an Github::ResponseWrapper
      languages.should have(2).keys
    end

    it "should get language information" do
      languages = subject.languages user, repo
      languages.keys.first.should == 'Ruby'
    end

    it "should yield to a block" do
      subject.should_receive(:languages).with(user, repo).and_yield('web')
      subject.languages(user, repo) { |param| 'web'}
    end
  end

  context "resource not found" do
    let(:body)   { '' }
    let(:status) { 404 }

    it "should fail to get resource" do
      expect {
        subject.languages user, repo
      }.to raise_error(Github::Error::NotFound)
    end
  end
end # languages
