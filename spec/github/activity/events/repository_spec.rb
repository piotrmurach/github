# encoding: utf-8

require 'spec_helper'

describe Github::Activity::Events, '#repository' do
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/events" }
  let(:body) { fixture('events/events.json') }
  let(:status) { 200 }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  context "resource found" do
    it { should respond_to :repo }

    it { should respond_to :repo_events }

    it "should fail to get resource without username" do
      expect { subject.repository nil, repo }.to raise_error(ArgumentError)
    end

    it "should get the resources" do
      subject.repository user, repo
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      def requestable
        subject.repository user, repo
      end
    end

    it "should get event information" do
      events = subject.repository user, repo
      events.first.type.should == 'Event'
    end

    it "should yield to a block" do
      subject.should_receive(:repository).with(user, repo).and_yield('web')
      subject.repository(user, repo) { |param| 'web' }
    end
  end

  context "resource not found" do
    let(:body) { '' }
    let(:status) { [404, "Not Found"] }

    it "should return 404 with a message 'Not Found'" do
      expect {
        subject.repository user, repo
      }.to raise_error(Github::Error::NotFound)
    end
  end
end # repository
