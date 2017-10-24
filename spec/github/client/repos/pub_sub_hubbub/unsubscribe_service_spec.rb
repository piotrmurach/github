# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::PubSubHubbub, '#unsubscribe_service' do
  let(:topic)  { "https://github.com/peter-murach/github/events/push"}
  let(:callback) { "github://campfire" }
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:service) { 'campfire' }

  after { reset_authentication_for subject }

  it { expect { subject.unsubscribe_service }.to raise_error(ArgumentError) }

  it "subscribes to service" do
    subject.should_receive(:unsubscribe).with(topic, callback)
    subject.unsubscribe_service user, repo, service
  end
end # unsubscribe_service
