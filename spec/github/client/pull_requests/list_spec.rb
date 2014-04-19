# encoding: utf-8

require 'spec_helper'

describe Github::Client::PullRequests, '#list' do
  let(:repo) { 'github' }
  let(:user) { 'peter-murach' }
  let(:inputs) { { 'state'=> 'closed', 'unrelated' => true } }
  let(:request_path) { "/repos/#{user}/#{repo}/pulls" }

  before {
    stub_get(request_path).with(:query => inputs.except('unrelated')).
    to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context 'resource found' do
    let(:body) { fixture('pull_requests/pull_requests.json') }
    let(:status) { 200 }

    it { should respond_to :all }

    it { expect { subject.list }.to raise_error(ArgumentError) }

    it { expect { subject.list user }.to raise_error(ArgumentError) }

    it "should get the resources" do
      subject.list user, repo, inputs
      a_get(request_path).with(:query => inputs.except('unrelated')).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list user, repo, inputs }
    end

    it "should get pull request information" do
      pull_requests = subject.list user, repo, inputs
      pull_requests.first.title.should == 'new-feature'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list(user, repo, inputs) { |obj| yielded << obj }
      yielded.should == result
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.list user, repo, inputs }
  end
end # list
