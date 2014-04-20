# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::PubSubHubbub, '#unsubscribe' do
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
    stub_post(request_path).with(hub_inputs.merge("hub.mode" => 'unsubscribe')).
      to_return(:body => '[]', :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})

  }

  after { reset_authentication_for subject }

  context "success" do
    let(:status) { 200 }

    it { expect { subject.unsubscribe }.to raise_error(ArgumentError) }

    it "should subscribe to hub" do
      subject.unsubscribe topic, callback
      a_post("/hub?access_token=#{OAUTH_TOKEN}").with(hub_inputs).should have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.unsubscribe topic, callback }
  end

#   context "failure" do
#     before do
#       subject.oauth_token = OAUTH_TOKEN
#       stub_post("/hub?access_token=#{OAUTH_TOKEN}").with(hub_inputs.merge("hub.mode" => 'unsubscribe')).
#         to_return(:body => '[]', :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
#     end
# 
#     it "should fail to subscribe to hub" do
#       expect {
#         subject.unsubscribe topic, callback
#       }.to raise_error(Github::Error::NotFound)
#     end
#   end
end # unsubscribe
