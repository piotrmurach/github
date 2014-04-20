# encoding: utf-8

require 'spec_helper'

describe Github::Client::Gists, '#star' do
  let(:gist_id) { 1 }
  let(:request_path) { "/gists/#{gist_id}/fork" }
  let(:body) { fixture('gists/gist.json') }
  let(:status) { 201 }

  before {
    stub_post(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  it "should fail to fork gist without gist id" do
    expect { subject.fork }.to raise_error(ArgumentError)
  end

  it "should fork resource successfully" do
    subject.fork gist_id
    a_post(request_path).should have_been_made
  end

  it "should return the resource" do
    gist = subject.fork gist_id
    gist.should be_a Github::ResponseWrapper
  end

  it "should get the gist information" do
    gist = subject.fork gist_id
    gist.user.login.should == 'octocat'
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.fork gist_id }
  end

end # fork
