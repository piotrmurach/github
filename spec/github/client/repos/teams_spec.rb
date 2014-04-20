# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos, '#teams' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/teams" }

  after { reset_authentication_for subject }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  context "resource found" do
   let(:body)   { fixture('repos/teams.json') }
   let(:status) { 200 }

    it "should raise error when no user/repo parameters" do
      expect { subject.teams nil, repo }.to raise_error(ArgumentError)
    end

    it "should raise error when no repository" do
      expect { subject.teams user, nil }.to raise_error(ArgumentError)
    end

    it "should find resources" do
      subject.teams user, repo
      a_get(request_path).should have_been_made
    end

    it "should return array of resources" do
      teams = subject.teams user, repo
      teams.should be_an Enumerable
      teams.should have(1).items
    end

    it "should get branch information" do
      teams = subject.teams user, repo
      teams.first.name.should == 'Owners'
    end

    it "should yield to a block" do
      subject.should_receive(:teams).with(user, repo).and_yield('web')
      subject.teams(user, repo) { |param| 'web'}
    end
  end

  context "resource not found" do
    let(:body)   { '' }
    let(:status) { 404 }

    it "should fail to get resource" do
      expect { subject.teams user, repo }.to raise_error(Github::Error::NotFound)
    end
  end
end # teams
