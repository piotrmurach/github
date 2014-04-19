# encoding: utf-8

require 'spec_helper'

describe Github::Client::Orgs, '#edit' do
  let(:org)   { 'github' }
  let(:request_path) { "/orgs/#{org}" }
  let(:body) { fixture("orgs/org.json") }
  let(:status) { 200 }
  let(:inputs) {
    { :billing_email => 'support@github.com',
      :blog => "https://github.com/blog",
      :company => "GitHub",
      :email => "support@github.com",
      :location => "San Francisco",
      :name => "github"
    }
  }

  before {
    stub_patch(request_path).with(inputs).
      to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource edited successfully" do

    it "should fail to edit without 'user/repo' parameters" do
      expect { subject.edit }.to raise_error(ArgumentError)
    end

    it "should edit the resource" do
      subject.edit org
      a_patch(request_path).with(inputs).should have_been_made
    end

    it "should return resource" do
      organisation = subject.edit org
      organisation.should be_a Github::ResponseWrapper
    end

    it "should be able to retrieve information" do
      organisation = subject.edit org
      organisation.name.should == 'github'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.edit org }
  end
end # edit
