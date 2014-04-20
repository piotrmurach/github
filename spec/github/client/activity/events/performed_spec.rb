# encoding: utf-8

require 'spec_helper'

describe Github::Client::Activity::Events, '#performed' do
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
      expect { subject.performed }.to raise_error(ArgumentError)
    end

    it "should get the resources" do
      subject.performed user
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.performed user }
    end

    it "should get event information" do
      events = subject.performed user
      events.first.type.should == 'Event'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.performed(user) { |obj| yielded << obj }
      yielded.should == result
    end
  end

  context "all public resources found" do
    let(:request_path) { "/users/#{user}/events/public" }

    it "should get the resources" do
      subject.performed user, :public => true
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.performed user, :public => true }
    end

    it "should get event information" do
      events = subject.performed user, :public => true
      events.first.type.should == 'Event'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.performed(user, :public => true) { |obj| yielded << obj }
      yielded.should == result
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.performed user }
  end

end # performed
