# encoding: utf-8

require 'spec_helper'

describe Github::Client::Users::Emails, '#list' do
  let(:email) { "octocat@github.com" }
  let(:request_path) { "/user/emails" }

  before {
    subject.oauth_token = OAUTH_TOKEN
    stub_get(request_path).with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found for an authenticated user" do
    let(:body) { fixture('users/emails.json') }
    let(:status) { 200 }

    it { should respond_to :all }

    it "should get the resources" do
      subject.list
      a_get(request_path).with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
        should have_been_made
    end

    it "should return resource" do
      emails = subject.list
      emails.should be_an Enumerable
      emails.should have(2).items
    end

    it "should get emails information" do
      emails = subject.list
      emails.first.should == email
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list { |obj| yielded << obj }
      yielded.should == result
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.list }
  end

end # list
