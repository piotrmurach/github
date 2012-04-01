require 'spec_helper'

describe Github::Repos::PubSubHubbub do
  let(:github) { Github.new }
  let(:topic)  { "https://github.com/peter-murach/github/events/push"}
  let(:callback) { "github://campfire?subdomain=github&room=Commits&token=abc123" }
  let(:hub_inputs) {
    {
       "hub.mode" => 'subscribe',
       "hub.topic" => topic,
       "hub.callback" => callback,
       "hub.verify"   => 'sync',
       "hub.secret"   => ''
    }
  }

  after { github.user, github.repo, github.oauth_token = nil, nil, nil }

  describe "subscribe" do
    context "success" do
      before do
        github.oauth_token = OAUTH_TOKEN
        stub_post("/hub?access_token=#{OAUTH_TOKEN}").with(hub_inputs).
          to_return(:body => '', :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should subscribe to hub" do
        github.repos.pubsubhubbub.subscribe topic, callback
        a_post("/hub?access_token=#{OAUTH_TOKEN}").with(hub_inputs).should have_been_made
      end
    end

    context "failure" do
      before do
        github.oauth_token = OAUTH_TOKEN
        stub_post("/hub?access_token=#{OAUTH_TOKEN}").with(hub_inputs).
          to_return(:body => '', :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to subscribe to hub" do
        expect {
          github.repos.pubsubhubbub.subscribe topic, callback
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # subscribe

  describe "unsubscribe" do
    context "success" do
      before do
        github.oauth_token = OAUTH_TOKEN
        stub_post("/hub?access_token=#{OAUTH_TOKEN}").with(hub_inputs.merge("hub.mode" => 'unsubscribe')).
          to_return(:body => '', :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should subscribe to hub" do
        github.repos.pubsubhubbub.unsubscribe topic, callback
        a_post("/hub?access_token=#{OAUTH_TOKEN}").with(hub_inputs).should have_been_made
      end
    end

    context "failure" do
      before do
        github.oauth_token = OAUTH_TOKEN
        stub_post("/hub?access_token=#{OAUTH_TOKEN}").with(hub_inputs.merge("hub.mode" => 'unsubscribe')).
          to_return(:body => '', :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to subscribe to hub" do
        expect {
          github.repos.pubsubhubbub.unsubscribe topic, callback
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # unsubscribe
end # Github::Repos::PubSubHubbub
