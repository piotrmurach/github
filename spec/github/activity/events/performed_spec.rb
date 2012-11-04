# encoding: utf-8

require 'spec_helper'

describe Github::Activity::Events, '#performed' do
  let(:user)   { 'peter-murach' }
  let(:request_path) { "/users/#{user}/events" }
  let(:body) { fixture('events/events.json') }
  let(:status) { 200 }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  context "resource found" do

    it "should fail to get resource without username" do
      expect { subject.performed nil }.to raise_error(ArgumentError)
    end

    it "should get the resources" do
      subject.performed user
      a_get(request_path).should have_been_made
    end

    it "should return array of resources" do
      events = subject.performed user
      events.should be_an Array
      events.should have(1).items
    end

    it "should be a mash type" do
      events = subject.performed user
      events.first.should be_a Hashie::Mash
    end

    it "should get event information" do
      events = subject.performed user
      events.first.type.should == 'Event'
    end

    it "should yield to a block" do
      subject.should_receive(:performed).with(user).and_yield('web')
      subject.performed(user) { |param| 'web' }
    end
  end

  context "all public resources found" do
    let(:request_path) { "/users/#{user}/events/public" }

    it "should get the resources" do
      subject.performed user, :public => true
      a_get(request_path).should have_been_made
    end

    it "should return array of resources" do
      events = subject.performed user, :public => true
      events.should be_an Array
      events.should have(1).items
    end

    it "should be a mash type" do
      events = subject.performed user, :public => true
      events.first.should be_a Hashie::Mash
    end

    it "should get event information" do
      events = subject.performed user, :public => true
      events.first.type.should == 'Event'
    end

    it "should yield to a block" do
      subject.should_receive(:performed).with(user).and_yield('web')
      subject.performed(user) { |param| 'web' }
    end
  end

  context "resource not found" do
    let(:body) { '' }
    let(:status) { [404, "Not Found"] }

    it "should return 404 with a message 'Not Found'" do
      expect {
        subject.performed user
      }.to raise_error(Github::Error::NotFound)
    end
  end
end # performed
