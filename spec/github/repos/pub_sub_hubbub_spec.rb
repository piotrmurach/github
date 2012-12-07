require 'spec_helper'

describe Github::Repos::PubSubHubbub do
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

  after { reset_authentication_for subject }

  describe "subscribe" do
    context "success" do
      before do
        subject.oauth_token = OAUTH_TOKEN
        stub_post("/hub?access_token=#{OAUTH_TOKEN}").with(hub_inputs).
          to_return(:body => '[]', :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should subscribe to hub" do
        subject.subscribe topic, callback
        a_post("/hub?access_token=#{OAUTH_TOKEN}").with(hub_inputs).should have_been_made
      end
    end

    context "failure" do
      before do
        subject.oauth_token = OAUTH_TOKEN
        stub_post("/hub?access_token=#{OAUTH_TOKEN}").with(hub_inputs).
          to_return(:body => '[]', :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to subscribe to hub" do
        expect {
          subject.subscribe topic, callback
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # subscribe

  describe "unsubscribe" do
    context "success" do
      before do
        subject.oauth_token = OAUTH_TOKEN
        stub_post("/hub?access_token=#{OAUTH_TOKEN}").with(hub_inputs.merge("hub.mode" => 'unsubscribe')).
        to_return(:body => '[]', :status => 200,
          :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should subscribe to hub" do
        subject.unsubscribe topic, callback
        a_post("/hub?access_token=#{OAUTH_TOKEN}").with(hub_inputs).should have_been_made
      end
    end

    context "failure" do
      before do
        subject.oauth_token = OAUTH_TOKEN
        stub_post("/hub?access_token=#{OAUTH_TOKEN}").with(hub_inputs.merge("hub.mode" => 'unsubscribe')).
          to_return(:body => '[]', :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to subscribe to hub" do
        expect {
          subject.unsubscribe topic, callback
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # unsubscribe
end # Github::Repos::PubSubHubbub
