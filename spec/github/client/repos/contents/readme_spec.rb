# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Contents, '#readme' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/readme" }

  before {
    stub_get(request_path).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  let(:body) { fixture('repos/readme.json') }
  let(:status) { 200 }

  it "should get the resources" do
    subject.readme user, repo
    a_get(request_path).should have_been_made
  end

  it "should get readme information" do
    readme = subject.readme user, repo
    readme.name.should == 'README.md'
  end
end
