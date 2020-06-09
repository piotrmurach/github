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

    it { is_expected.to respond_to :all }

    it "should get the resources" do
      subject.list
      expect(a_get(request_path).with(:query => { :access_token => "#{OAUTH_TOKEN}"})).
        to have_been_made
    end

    it "should return resource" do
      emails = subject.list
      expect(emails).to be_an Enumerable
      expect(emails.size).to be 2
    end

    it "should get emails information" do
      emails = subject.list
      expect(emails.first).to eq email
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list { |obj| yielded << obj }
      expect(yielded).to eq result
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.list }
  end

end # list
