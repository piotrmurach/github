require 'spec_helper'

describe Github::Events do

  let(:github) { Github.new }

  describe "public_events" do
    context "resource found" do
      before do
        stub_get("/events").
          to_return(:body => fixture('events/events.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the resources" do
        github.events.public_events
        a_get("/events").should have_been_made
      end

      it "should return array of resources" do
        events = github.events.public_events
        events.should be_an Array
        events.should have(1).items
      end

      it "should be a mash type" do
        events = github.events.public_events
        events.first.should be_a Hashie::Mash
      end

      it "should get event information" do
        events = github.events.public_events
        events.first.type.should == 'Event'
      end

      it "should yield to a block" do
        github.events.should_receive(:public_events).and_yield('web')
        github.events.public_events { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/events").to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.events.public_events
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # public_events

end
