# encoding: utf-8

require 'spec_helper'

describe Github::Client::PullRequests, '#files' do
  let(:repo) { 'github' }
  let(:user) { 'peter-murach' }
  let(:number) { 1 }
  let(:request_path) {  "/repos/#{user}/#{repo}/pulls/#{number}/files" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context 'resource found' do
    let(:body) { fixture('pull_requests/files.json') }
    let(:status) { 200 }

    it { expect { subject.files }.to raise_error(ArgumentError) }

    it { expect { subject.files user }.to raise_error(ArgumentError) }

    it "should get the resources" do
      subject.files user, repo, number
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.files user, repo, number }
    end

    it "should get pull request information" do
      pull_requests = subject.files user, repo, number
      pull_requests.first.filename.should == 'file1.txt'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.files(user, repo, number) { |obj| yielded << obj }
      yielded.should == result
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.files user, repo, number }
  end
end # files
