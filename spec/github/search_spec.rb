# encoding: utf-8

require 'spec_helper'

describe Github::Search do
  let(:github) { Github.new }
  let(:keyword) { 'api' }

  after { reset_authentication_for(github) }

  context "#issues" do
    let(:owner) { 'peter-murach' }
    let(:repo)  { 'github' }
    let(:state) { 'closed' }

    before do
      stub_get("/legacy/issues/search/#{owner}/#{repo}/#{state}/#{keyword}").
        to_return(:body => fixture('search/issues.json'), :status => 200,
          :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the resources" do
      github.search.issues :owner => owner, :repo => repo, :state => state, :keyword => keyword
      a_get("/legacy/issues/search/#{owner}/#{repo}/#{state}/#{keyword}").should have_been_made
    end

    it "should get issue information" do
      issues = github.search.issues :owner => owner, :repo => repo, :state => state, :keyword => keyword
      issues.issues.first.user.should == 'ckarbass'
    end
  end

  context "#repositories" do
    before do
      stub_get("/legacy/repos/search/#{keyword}").
        to_return(:body => fixture('search/repositories.json'), :status => 200,
          :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the resources" do
      github.search.repos :keyword => keyword
      a_get("/legacy/repos/search/#{keyword}").should have_been_made
    end

    it "should get repository information" do
      repos = github.search.repos :keyword => keyword
      repos.repositories.first.username.should == 'mathiasbynens'
    end
  end

  context "#users" do
    before do
      stub_get("/legacy/user/search/#{keyword}").
        to_return(:body => fixture('search/users.json'), :status => 200,
          :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the resources" do
      github.search.users :keyword => keyword
      a_get("/legacy/user/search/#{keyword}").should have_been_made
    end

    it "should get user information" do
      users = github.search.users :keyword => keyword
      users.users.first.username.should == 'techno'
    end
  end

  context "#email" do
    before do
      stub_get("/legacy/user/email/#{keyword}").
        to_return(:body => fixture('search/email.json'), :status => 200,
          :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the resources" do
      github.search.email :email => keyword
      a_get("/legacy/user/email/#{keyword}").should have_been_made
    end

    it "should get user information" do
      user = github.search.email :email => keyword
      user.user.username.should == 'techno'
    end
  end

end # Github::Search
