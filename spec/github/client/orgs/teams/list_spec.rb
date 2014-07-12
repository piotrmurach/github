# encoding: utf-8

require 'spec_helper'

describe Github::Client::Orgs::Teams, '#list' do
  let(:org) { 'github' }
  let(:body) { fixture('orgs/teams.json') }
  let(:status) { 200 }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found for the organization" do
    let(:request_path) { "/orgs/#{org}/teams" }

    it "should get the resources" do
      subject.list org: org
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list org: org }
    end

    it "should get teams information" do
      teams = subject.list org: org
      teams.first.name.should == 'Owners'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list(org: org) { |obj| yielded << obj }
      yielded.should == result
    end

    it_should_behave_like 'request failure' do
      let(:requestable) { subject.list org: org }
    end
  end

  context "resource found for the authenticated user" do
    let(:request_path) { "/user/teams" }

    it "should get the resources" do
      subject.list
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list }
    end

    it "should get teams information" do
      teams = subject.list
      teams.first.name.should == 'Owners'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list { |obj| yielded << obj }
      yielded.should == result
    end

    it_should_behave_like 'request failure' do
      let(:requestable) { subject.list }
    end
  end
end # list
