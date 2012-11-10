# encoding: utf-8

require 'spec_helper'

describe Github::Activity::Events, '#org' do
  let(:org) { 'github' }
  let(:request_path) { "/orgs/#{org}/events" }
  let(:body) { fixture('events/events.json') }
  let(:status) { 200 }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  context "resource found" do
    it { should respond_to :organization }

    it "should fail to get resource without orgname" do
      expect { subject.org nil }.to raise_error(ArgumentError)
    end

    it "should get the resources" do
      subject.org org
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      def requestable
        subject.org org
      end
    end

    it "should get event information" do
      events = subject.org org
      events.first.type.should == 'Event'
    end

    it "should yield to a block" do
      subject.should_receive(:org).with(org).and_yield('web')
      subject.org(org) { |param| 'web' }
    end
  end

  context "resource not found" do
    let(:body) { '' }
    let(:status) { [404, "Not Found"] }

    it "should return 404 with a message 'Not Found'" do
      expect { subject.org org }.to raise_error(Github::Error::NotFound)
    end
  end
end # org
