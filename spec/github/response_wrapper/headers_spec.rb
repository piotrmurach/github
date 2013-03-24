# encoding: utf-8

require 'spec_helper'

describe Github::ResponseWrapper, '#headers' do
  let(:env) {
    { :response_headers => {
      'Content-Type' => "application/json; charset=utf-8",
      'X-RateLimit-Remaining' => '4999',
      'X-RateLimit-Limit' => '5000',
      'content-length' => '344',
      'ETag' => "\"d9a88f20567726e29d35c6fae87cef2f\"",
      'Server' => "nginx/1.0.4",
      'Date' => "Sun, 05 Feb 2012 15:02:34 GMT",
    }, :body => ['some'], :status => 200 }
  }
  let(:res) { Faraday::Response.new env }
  let(:object) { described_class.new res, nil }

  subject { object.headers }

  its(:content_type) { should match 'application/json' }

  its(:content_length) { should match '344' }

  its(:ratelimit_limit) { should == '5000' }

  its(:ratelimit_remaining) { should == '4999' }

  its(:status) { should be 200 }

  its(:etag) { should eql "\"d9a88f20567726e29d35c6fae87cef2f\"" }

  its(:date) { should eql "Sun, 05 Feb 2012 15:02:34 GMT" }

  its(:server) { should eql "nginx/1.0.4" }
end
