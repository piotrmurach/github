require 'spec_helper'

describe Github::Result do

  let(:github) { Github.new }
  let(:res)    { github.events.public }

  before do
    stub_get("/events").
      to_return(:body => fixture('events/events.json'),
        :status => 200,
        :headers => {
          :content_type => "application/json; charset=utf-8",
          'X-RateLimit-Remaining' => '4999',
          'content-length' => '344'
        })
  end

  it "should read response content_type " do
    res.content_type.should match 'application/json'
  end

  it "should read response content_length " do
    res.content_length.should match '344'
  end

  it "should read response ratelimit" do
    res.ratelimit.should == '4999'
  end

  it "should read response statsu" do
    res.status.should be 200
  end

  it "should assess successful" do
    res.success?.should be_true
  end

  it "should read response body" do
    res.body.should_not be_empty
  end

end # Github::Result
