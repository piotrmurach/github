# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::PubSubHubbub, '#subscribe_service' do
  let(:topic)  { "https://github.com/peter-murach/github/events/push"}
  let(:callback) { "github://campfire?subdomain=github&room=Commits" }
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:service) { 'campfire' }
  let(:options) {
    {
      :subdomain => 'github',
      :room => 'Commits'
    }
  }

  after { reset_authentication_for subject }

  it { expect { subject.subscribe_service }.to raise_error(ArgumentError) }

  it "subscribes to service" do
    subject.should_receive(:subscribe).with(topic, callback)
    subject.subscribe_service user, repo, service, options
  end
end # subscribe_service
