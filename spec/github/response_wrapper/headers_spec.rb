# encoding: utf-8

require 'spec_helper'

describe Github::ResponseWrapper, '#headers' do
  let(:env) {
    { :response_headers => {
      'Content-Type' => "application/json; charset=utf-8",
      'X-RateLimit-Remaining' => '4999',
      'X-RateLimit-Limit' => '5000',
      'X-RateLimit-Reset' => '1422262420',
      'content-length' => '344',
      'ETag' => "\"d9a88f20567726e29d35c6fae87cef2f\"",
      'Server' => "nginx/1.0.4",
      'Date' => "Sun, 05 Feb 2012 15:02:34 GMT",
    }, :body => ['some'], :status => 200 }
  }
  let(:res) { Faraday::Response.new env }
  let(:object) { described_class.new res, nil }

  subject { object.headers }

  its(:content_type) { is_expected.to match 'application/json' }

  its(:content_length) { is_expected.to match '344' }

  its(:ratelimit_limit) { is_expected.to eq '5000' }

  its(:ratelimit_remaining) { is_expected.to eq '4999' }

  its(:ratelimit_reset) { is_expected.to eq '1422262420' }

  its(:status) { is_expected.to be 200 }

  its(:etag) { is_expected.to eql "\"d9a88f20567726e29d35c6fae87cef2f\"" }

  its(:date) { is_expected.to eql "Sun, 05 Feb 2012 15:02:34 GMT" }

  its(:server) { is_expected.to eql "nginx/1.0.4" }
end
