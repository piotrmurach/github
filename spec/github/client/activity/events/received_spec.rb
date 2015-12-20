# encoding: utf-8

require 'spec_helper'

describe Github::Client::Activity::Events, '#received' do
  let(:user)   { 'peter-murach' }
  let(:request_path) { "/users/#{user}/received_events" }
  let(:body) { fixture('events/events.json') }
  let(:status) { 200 }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  context "resource found" do

    it "should fail to get resource without username" do
      expect { subject.received }.to raise_error(ArgumentError)
    end

    it "should get the resources" do
      subject.received user
      expect(a_get(request_path)).to have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.received user }
    end

    it "should get event information" do
      events = subject.received user
      expect(events.first.type).to eq('Event')
    end

    it "should yield to a block" do
      yielded = []
      result = subject.received(user) { |obj| yielded << obj }
      expect(yielded).to eq(result)
    end
  end

  context "all public resources found" do
    let(:request_path) { "/users/#{user}/received_events/public" }

    it "should get the resources" do
      subject.received user, :public => true
      expect(a_get(request_path)).to have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.received user, :public => true }
    end

    it "should get event information" do
      events = subject.received user, :public => true
      expect(events.first.type).to eq('Event')
    end

    it "should yield to a block" do
      yielded = []
      result = subject.received(user, :public => true) { |obj| yielded << obj }
      expect(yielded).to eq(result)
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.received user }
  end
end # received
