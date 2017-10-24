# encoding: utf-8

require 'spec_helper'

describe Github::ResponseWrapper, 'overwrites' do
  let(:object) { described_class.new res, nil }
  let(:env) {
     { :status => 404, :body => body,
      :response_headers => {'Content-Type' => 'text/plain'} }
  }
  let(:res) { Faraday::Response.new env }
  let(:body) { {'id' => 2456210, 'fork' => false, 'type' => 'repo' } }

  it { expect(object.id).to eql(2456210) }

  it { expect(object.fork).to be_false }

  it { expect(object.type).to eql('repo') }
end
