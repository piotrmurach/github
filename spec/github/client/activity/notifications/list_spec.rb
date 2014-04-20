# encoding: utf-8

require 'spec_helper'

describe Github::Client::Activity::Notifications, '#list' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }

  before { subject.oauth_token = OAUTH_TOKEN }

  after { reset_authentication_for subject }

  context 'resource found for authenticated user' do
    let(:request_path) { "/notifications" }
    let(:body)   { fixture('activity/notifications.json') }
    let(:status) { 200 }

    before {
      stub_get(request_path).with(:query => {:access_token => OAUTH_TOKEN }).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
    }

    it { should respond_to :all }

    it 'filters unknown parameters' do
      subject.list :unknown => true
      a_get(request_path).with(:query => {:access_token => OAUTH_TOKEN}).
        should have_been_made
    end

    it 'should get the resource' do
      subject.list
      a_get(request_path).with(:query => {:access_token => OAUTH_TOKEN}).
        should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list }
    end

    it "should get resource information" do
      notifications = subject.list
      notifications.first.repository.name.should == 'Hello-World'
    end

    it "should yield repositories to a block" do
      subject.should_receive(:list).and_yield('octocat')
      subject.list { |repo| 'octocat' }
    end

    it_should_behave_like 'request failure' do
      let(:requestable) { subject.list }
    end
  end

  context 'resource found for repository' do
    let(:body) { fixture('activity/notifications.json') }
    let(:status) { 200 }
    let(:request_path) { "/repos/#{user}/#{repo}/notifications"}

    before {
      stub_get(request_path).with(:query => {:access_token => OAUTH_TOKEN}).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
    }

    it "should get the resource" do
      subject.list :user => user, :repo => repo
      a_get(request_path).with(:query => {:access_token => OAUTH_TOKEN}).
        should have_been_made
    end
  end

end
