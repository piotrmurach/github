# encoding: utf-8

require 'spec_helper'

describe Github::Client do
  let(:github) { Github.new }

  after { reset_authentication_for github }

  it "should return Github::Gists instance" do
    github.gists.should be_a Github::Gists
  end

  it "should return Github::GitData instance" do
    github.git_data.should be_a Github::GitData
  end

  it "should return Github::Issues instance" do
    github.issues.should be_a Github::Issues
  end

  it "should return Github::Orgs instance" do
    github.orgs.should be_a Github::Orgs
  end

  it "should return Github::PullRequests instance" do
    github.pull_requests.should be_a Github::PullRequests
  end

  it "should return Github::Repos instance" do
    github.repos.should be_a Github::Repos
  end

  it "should return Github::Users instance" do
    github.users.should be_a Github::Users
  end

  it "should return Github::Authorizations instance" do
    github.oauth.should be_a Github::Authorizations
  end

  it "should respond to repos" do
    github.should respond_to :repos
  end

  it "should respond to repositories" do
    github.should respond_to :repositories
  end

  it "should respond to git_data" do
    github.should respond_to :git_data
  end

  it "should respond to git" do
    github.should respond_to :git
  end
end
