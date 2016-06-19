# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Activity::Feeds, '#list' do
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

    it 'gets the resource' do
      subject.list
      expect(a_get(request_path).with(:query => {:access_token => OAUTH_TOKEN})).
        to have_been_made
    end

    it "gets timeline url" do
      feeds = subject.list
      expect(feeds.timeline_url).to eq('https://github.com/timeline')
    end

    it "gest user url" do
      feeds = subject.list
      expect(feeds.user_url).to eq('https://github.com/{user}')
    end

    it "gets current user public url" do
      feeds = subject.list
      expect(feeds.current_user_public_url).to eq('https://github.com/defunkt')
    end

    it "gets current user url" do
      feeds = subject.list
      expect(feeds.current_user_url).to eq('https://github.com/defunkt.private?token=abc123')
    end

    it "gets current user actor url" do
      feeds = subject.list
      expect(feeds.current_user_actor_url).to eq('https://github.com/defunkt.private.actor?token=abc123')
    end

    it "gets current user organization url" do
      feeds = subject.list
      expect(feeds.current_user_organization_url).to eq('')
    end

    it "gets current user public url" do
      feeds = subject.list
      expect(feeds.current_user_organization_urls.first).to eq('https://github.com/organizations/github/defunkt.private.atom?token=abc123')
    end

    it_should_behave_like 'request failure' do
      let(:requestable) { subject.list }
    end
  end
end
