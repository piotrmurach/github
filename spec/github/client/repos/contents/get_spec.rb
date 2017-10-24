# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Contents, '#get' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:path) { 'README.md' }
  let(:request_path) { "/repos/#{user}/#{repo}/contents/#{path}" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  let(:path) { 'README.md' }
  let(:body) { fixture('repos/content.json') }
  let(:status) { 200 }

  it { expect { subject.get user, repo }.to raise_error(ArgumentError) }

  it { expect { subject.get }.to raise_error(ArgumentError)}

  it "should get the resources" do
    subject.get user, repo, path
    a_get(request_path).should have_been_made
  end

  it "should get repository information" do
    content = subject.get user, repo, path
    content.name.should == 'README.md'
  end
end
