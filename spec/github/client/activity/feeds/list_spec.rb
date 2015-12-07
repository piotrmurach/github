# encoding: utf-8

require 'spec_helper'

describe Github::Client::Activity::Feeds, '#list' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }

  before { subject.oauth_token = OAUTH_TOKEN }

  after { reset_authentication_for subject }

  context 'resource found for authenticated user' do
    let(:request_path) { "/feeds" }
    let(:body)   { fixture('activity/feeds.json') }
    let(:status) { 200 }

    before {
      stub_get(request_path).with(:query => {:access_token => OAUTH_TOKEN }).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
    }

    it { should respond_to :all }

    it 'should get the resource' do
      subject.list
      a_get(request_path).with(:query => {:access_token => OAUTH_TOKEN}).
        should have_been_made
    end

    it "should get timeline url" do
      feeds = subject.list
      feeds.timeline_url.should == 'https://github.com/timeline'
    end

    it "should get user url" do
      feeds = subject.list
      feeds.user_url.should == 'https://github.com/{user}'
    end

    it "should get current user public url" do
      feeds = subject.list
      feeds.current_user_public_url.should == 'https://github.com/defunkt'
    end

    it "should get current user url" do
      feeds = subject.list
      feeds.current_user_url.should == 'https://github.com/defunkt.private?token=abc123'
    end

    it "should get current user actor url" do
      feeds = subject.list
      feeds.current_user_actor_url.should == 'https://github.com/defunkt.private.actor?token=abc123'
    end

    it "should get current user organization url" do
      feeds = subject.list
      feeds.current_user_organization_url.should == ''
    end

    it "should get current user public url" do
      feeds = subject.list
      feeds.current_user_organization_urls.first.should == 'https://github.com/organizations/github/defunkt.private.atom?token=abc123'
    end

    it_should_behave_like 'request failure' do
      let(:requestable) { subject.list }
    end
  end

end
