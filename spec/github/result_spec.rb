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
          'X-RateLimit-Limit' => '5000',
          'content-length' => '344'
        })
  end

  it "should read response content_type " do
    res.content_type.should match 'application/json'
  end

  it "should read response content_length " do
    res.content_length.should match '344'
  end

  it "should read response ratelimit limit" do
    res.ratelimit_limit.should == '5000'
  end

  it "should read response ratelimit remaining" do
    res.ratelimit_remaining.should == '4999'
  end

  it "should read response status" do
    res.status.should be 200
  end

  it "should assess successful" do
    res.success?.should be_true
  end

  it "should read response body" do
    res.body.should_not be_empty
  end

  context "pagination methods" do
    let(:env) { {:response_headers => {}}}
    let(:iterator) { mock(Github::PageIterator.new(env)).as_null_object }
    let(:items) { [] }

    before do
      described_class.stub(:page_iterator).and_return iterator
      @items.stub(:env).and_return env
    end

    it "should respond to links" do
      res.links.should be_a Github::PageLinks
    end

    %w[ first next prev last].each do |link|
      it "should return #{link} page if exists" do
        res.send(:"#{link}_page").should eq @items
      end
    end

    it 'checks if there are more pages' do
      res.should_receive(:has_next_page?).and_return true
      res.has_next_page?.should be_true
    end

  end # pagination

end # Github::Result
