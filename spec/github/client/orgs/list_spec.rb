# encoding: utf-8

require 'spec_helper'

describe Github::Client::Orgs, '#list' do
  let(:user) { 'peter-murach' }
  let(:body) { fixture('orgs/orgs.json') }
  let(:status) { 200 }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found for a user" do
    let(:request_path) { "/users/#{user}/orgs" }

    it "should get the resources" do
      subject.list :user => user
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list :user => user }
    end

    it "should get org information" do
      orgs = subject.list :user => user
      orgs.first.login.should == 'github'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list(:user => user) { |obj| yielded << obj }
      yielded.should == result
    end

    it_should_behave_like 'request failure' do
      let(:requestable) { subject.list :user => user }
    end
  end

  context "resource found for an au user" do
    let(:request_path) { "/user/orgs" }

    before do
      subject.oauth_token = OAUTH_TOKEN
      stub_get(request_path).
        with(:query => { :access_token => OAUTH_TOKEN }).
        to_return(:body => fixture('orgs/orgs.json'), :status => status,
          :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the resources" do
      subject.list
      a_get(request_path).with(:query => { :access_token => OAUTH_TOKEN }).
        should have_been_made
    end
  end
end # list
