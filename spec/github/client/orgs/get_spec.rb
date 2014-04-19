# encoding: utf-8

require 'spec_helper'

describe Github::Client::Orgs, '#get' do
  let(:org)   { 'github' }
  let(:request_path) {  "/orgs/#{org}" }
  let(:body) { fixture('orgs/org.json') }
  let(:status) { 200 }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    it "should fail to get resource without org name" do
      expect { subject.get }.to raise_error(ArgumentError)
    end

    it "should get the resource" do
      subject.get org
      a_get(request_path).should have_been_made
    end

    it "should get org information" do
      organisation = subject.get org
      organisation.id.should == 1
      organisation.login.should == 'github'
    end

    it "should return mash" do
      organisation = subject.get org
      organisation.should be_a Github::ResponseWrapper
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get org }
  end
end # get
