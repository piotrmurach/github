# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::PubSubHubbub, '#subscribe' do
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

  let(:request_path) { "/hub?access_token=#{OAUTH_TOKEN}" }

  before {
    subject.oauth_token = OAUTH_TOKEN
    stub_post(request_path).with(hub_inputs).
      to_return(:body => '[]', :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})

  }

  after { reset_authentication_for subject }

  context "success" do
    let(:status) { 200 }

    it { expect { subject.subscribe }.to raise_error(ArgumentError) }

    it { expect { subject.subscribe topic, nil}.to raise_error(ArgumentError) }

    it "subscribes to hub" do
      subject.subscribe topic, callback
      a_post("/hub?access_token=#{OAUTH_TOKEN}").with(hub_inputs).should have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.subscribe topic, callback }
  end
end # subscribe
