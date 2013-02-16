# encoding: utf-8

require 'spec_helper'

describe Github::Result do
  let(:github) { Github.new }
  let(:user)   { 'wycats' }
  let(:res)    { github.activity.events.public({ 'per_page' => 20 }) }
  let(:pages)  { ['1', '5', '6'] }
  let(:link) {
    "<https://api.github.com/users/wycats/repos?page=6&per_page=20>; rel=\"last\", <https://api.github.com/users/wycats/repos?page=1&per_page=20>; rel=\"first\""
  }

  before do
    stub_get("/events").
      with(:query => { 'per_page' => '20' }).
      to_return(:body => fixture('events/events.json'),
        :status => 200,
        :headers => {
          :content_type => "application/json; charset=utf-8",
          'X-RateLimit-Remaining' => '4999',
          'X-RateLimit-Limit' => '5000',
          'content-length' => '344',
          'etag' => "\"d9a88f20567726e29d35c6fae87cef2f\"",
          'server' => "nginx/1.0.4",
          'Date' => "Sun, 05 Feb 2012 15:02:34 GMT",
          'Link' => link
        })

    ['', '1', '5', '6'].each do |page|
    params = page.empty? ? {'per_page'=>'20'} : {'per_page'=>'20', 'page'=>page}
    stub_get("/users/#{user}/repos").
      with(:query => params).
      to_return(:body => fixture('events/events.json'),
        :status => 200,
        :headers => {
          :content_type => "application/json; charset=utf-8",
          'X-RateLimit-Remaining' => '4999',
          'X-RateLimit-Limit' => '5000',
          'content-length' => '344',
          'Date' => "Sun, 05 Feb 2012 15:02:34 GMT",
          'Link' => link
        })
    end
  end

  it "should read response content_type " do
    res.headers.content_type.should match 'application/json'
  end

  it "should read response content_length " do
    res.headers.content_length.should match '344'
  end

  it "should read response ratelimit limit" do
    res.headers.ratelimit_limit.should == '5000'
  end

  it "should read response ratelimit remaining" do
    res.headers.ratelimit_remaining.should == '4999'
  end

  it "should read response status" do
    res.headers.status.should be 200
  end

  it 'should read response etag' do
    res.headers.etag.should eql "\"d9a88f20567726e29d35c6fae87cef2f\""
  end

  it 'should read response date' do
    res.headers.date.should eql "Sun, 05 Feb 2012 15:02:34 GMT"
  end

  it 'should read response server' do
    res.headers.server.should eql "nginx/1.0.4"
  end

  it "should assess successful" do
    res.success?.should be_true
  end

  it "should read response body" do
    res.body.should_not be_empty
  end

  context "pagination methods" do
    let(:links) { Github::PageLinks.new({}) }
    let(:current_api) { stub(:api).as_null_object }
    let(:iterator) { Github::PageIterator.new(links, current_api) }

    before do
      described_class.stub(:page_iterator).and_return iterator
    end

    it "should respond to links" do
      res.links.should be_a Github::PageLinks
    end

    %w[ next prev ].each do |link|
      context "#{link}_page" do
        it "responds to #{link}_page request" do
          res.send(:"#{link}_page").should be_nil
        end

        it 'should have no link information' do
          res.links.send(:"#{link}").should be_nil
        end
      end
    end

    %w[ first last].each do |link|
      context "#{link}_page" do
        it "should return resource if exists" do
          res.send(:"#{link}_page").should_not be_empty
        end

        it "should have link information" do
          res.send(:"#{link}_page").should_not be_nil
        end
      end
    end

    it 'finds single page successfully' do
      iterator.stub(:get_page).and_return res
      res.page(5).should eq res
    end

    it 'checks if there are more pages' do
      res.should_receive(:has_next_page?).and_return true
      res.has_next_page?.should be_true
    end

  end # pagination

end # Github::Result
