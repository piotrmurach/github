# encoding: utf-8

require 'spec_helper'

describe Github::Client::Activity::Notifications, '#get' do
  let(:thread_id) { 1 }
  let(:request_path) { "/notifications/threads/#{thread_id}" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  context "resource found" do
    let(:body)   { fixture('activity/threads.json') }
    let(:status) { 200 }

    it { should respond_to(:find) }

    it "should raise error when no thread-id parameter" do
      expect { subject.get }.to raise_error(ArgumentError)
    end

    it "should find resources" do
      subject.get thread_id
      a_get(request_path).should have_been_made
    end

    it "should return repository mash" do
      threads = subject.get thread_id
      threads.should be_an Enumerable
      threads.should have(1).items
    end

    it "should get repository information" do
      threads = subject.get thread_id
      threads.first.repository.name.should == 'Hello-World'
    end

    it "should yield repositories to a block" do
      subject.should_receive(:get).and_yield('octocat')
      subject.get(thread_id) { |repo| 'octocat' }
    end
  end

  context "resource not found" do
    let(:body)   { '' }
    let(:status) { 404 }

    it "should fail to get resource" do
      expect {
        subject.get thread_id
      }.to raise_error(Github::Error::NotFound)
    end
  end
end # get
