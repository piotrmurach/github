# encoding: utf-8

require 'spec_helper'

describe Github::Client::Gists, '#starred' do
  let(:request_path) { "/gists/starred" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body) { fixture('gists/gists.json') }
    let(:status) { 200 }

    it "should get the resources" do
      subject.starred
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.starred }
    end

    it "should get gist information" do
      gists = subject.starred
      gists.first.user.login.should == 'octocat'
    end

    it "should yield to a block" do
        yielded = []
        result = subject.starred { |obj| yielded << obj }
        yielded.should == result
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.starred }
  end

end # starred
