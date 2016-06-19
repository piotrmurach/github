# encoding: utf-8

require 'spec_helper'

describe Github::Client::Orgs::Members, '#list' do
  let(:org) { 'github' }
  let(:body) { fixture('orgs/members.json') }
  let(:status) { 200 }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:request_path) { "/orgs/#{org}/members" }

    it { should respond_to :all }

    it "should fail to get resource without org name" do
      expect { subject.list }.to raise_error(ArgumentError)
    end

    it "should get the resources" do
      subject.list org
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list org }
    end

    it "should get members information" do
      members = subject.list org
      members.first.login.should == 'octocat'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list(org) { |obj| yielded << obj }
      yielded.should == result
    end

    it_should_behave_like 'request failure' do
      let(:requestable) { subject.list org }
    end
  end

  context "resource found" do
    let(:request_path) { "/orgs/#{org}/public_members" }

    it "should fail to get resource without org name" do
      expect { subject.list }.to raise_error(ArgumentError)
    end

    it "should get the resources" do
      subject.list org, :public => true
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list org, :public => true }
    end

    it "should get public_members information" do
      public_members = subject.list org, :public => true
      public_members.first.login.should == 'octocat'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list(org, :public => true) { |obj| yielded << obj }
      yielded.should == result
    end

    it_should_behave_like 'request failure' do
      let(:requestable) { subject.list org, :public => true }
    end
  end
end # list
