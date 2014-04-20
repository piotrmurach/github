# encoding: utf-8

require 'spec_helper'

describe Github::Client::Activity::Events, '#public' do
  let(:request_path) { "/events" }
  let(:body) { fixture('events/events.json') }
  let(:status) { 200 }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  context "resource found" do

    it "should get the resources" do
      subject.public
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.public }
    end

    it "should get event information" do
      events = subject.public
      events.first.type.should == 'Event'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.public { |obj| yielded << obj }
      yielded.should == result
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.public }
  end

end # public
