# encoding: utf-8

require 'spec_helper'

describe Github::Search do
  let(:keyword) { 'api' }

  after { reset_authentication_for(subject) }

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
      subject.issues owner, repo, state, keyword
      a_get("/legacy/issues/search/#{owner}/#{repo}/#{state}/#{keyword}").should have_been_made
    end

    it "should get the resources through params hash" do
      subject.issues :owner => owner, :repo => repo, :state => state, :keyword => keyword
      a_get("/legacy/issues/search/#{owner}/#{repo}/#{state}/#{keyword}").should have_been_made
    end

    it "should get issue information" do
      issues = subject.issues :owner => owner, :repo => repo, :state => state, :keyword => keyword
      issues.issues.first.user.should == 'ckarbass'
    end
  end

  context "#repositories" do
    before do
      stub_get("/legacy/repos/search/#{keyword}").
        to_return(:body => fixture('search/repositories.json'), :status => 200,
          :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it { expect { subject.repos }.to raise_error(ArgumentError) }

    it "should get the resources" do
      subject.repos keyword
      a_get("/legacy/repos/search/#{keyword}").should have_been_made
    end

    it "should get the resource through params hash" do
      subject.repos :keyword => keyword
      a_get("/legacy/repos/search/#{keyword}").should have_been_made
    end

    it "should get repository information" do
      repos = subject.repos :keyword => keyword
      repos.repositories.first.username.should == 'mathiasbynens'
    end
  end

  context "#users" do
    before do
      stub_get("/legacy/user/search/#{keyword}").
        to_return(:body => fixture('search/users.json'), :status => 200,
          :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it { expect { subject.users }.to raise_error(ArgumentError) }

    it "should get the resources" do
      subject.users :keyword => keyword
      a_get("/legacy/user/search/#{keyword}").should have_been_made
    end

    it "should get user information" do
      users = subject.users :keyword => keyword
      users.users.first.username.should == 'techno'
    end
  end

  context "#email" do
    before do
      stub_get("/legacy/user/email/#{keyword}").
        to_return(:body => fixture('search/email.json'), :status => 200,
          :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it { expect { subject.email }.to raise_error(Github::Error::RequiredParams) }

    it "should get the resources" do
      subject.email :email => keyword
      a_get("/legacy/user/email/#{keyword}").should have_been_made
    end

    it "should get user information" do
      user = subject.email :email => keyword
      user.user.username.should == 'techno'
    end
  end

end # Github::Search
