# encoding: utf-8

require 'spec_helper'

describe Github::Repos::Contents do
  let(:github) { Github.new }
  let(:user) { 'octokit' }
  let(:repo) { 'github' }

  after { reset_authentication_for(github) }

  context "#readme" do
    before do
      stub_get("/repos/#{user}/#{repo}/readme").
        to_return(:body => fixture('repos/readme.json'), :status => 200,
          :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the resources" do
      github.repos.contents.readme user, repo
      a_get("/repos/#{user}/#{repo}/readme").should have_been_made
    end

    it "should get readme information" do
      readme= github.repos.contents.readme user, repo
      readme.name.should == 'README.md'
    end
  end

  context "#get" do
    let(:path) { 'README.md' }

    before do
      stub_get("/repos/#{user}/#{repo}/contents/#{path}").
        to_return(:body => fixture('repos/content.json'), :status => 200,
          :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the resources" do
      github.repos.contents.get user, repo, path
      a_get("/repos/#{user}/#{repo}/contents/#{path}").should have_been_made
    end

    it "should get repository information" do
      content = github.repos.contents.get user, repo, path
      content.name.should == 'README.md'
    end
  end

  context "#users" do
    let(:archive_format) { 'tarball' }
    let(:ref) { 'master' }

    before do
      stub_get("/repos/#{user}/#{repo}/#{archive_format}/#{ref}").
        to_return(:body => '', :status => 302)
    end

    it "should get the resources" do
      github.repos.contents.archive user, repo, :archive_format => archive_format, :ref => ref
      a_get("/repos/#{user}/#{repo}/#{archive_format}/#{ref}").should have_been_made
    end
  end

end # Github::Repos::Contents
