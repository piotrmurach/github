# encoding: utf-8

require 'spec_helper'

describe Github::Request::Jsonize do

  let(:middleware) { described_class.new(lambda { |env| env }) }

  def process(body, content_type=nil)
    env = {:body => body, :request_headers => {} }
    env[:request_headers]['Content-Type'] = content_type if content_type
    middleware.call(env)
  end

  def result_body() result[:body] end
  def result_type() result[:request_headers]['Content-Type'] end

  context 'no body' do
    let(:result) { process(nil) }

    it "returns empty object" do
      expect(result_body).to be_nil
    end

    it "doesn't add content type" do
      expect(result_type).to be_nil
    end
  end

  context 'empty body' do
    let(:result) { process('') }

    it "returns empty object" do
      expect(result_body).to eq('')
    end

    it "doesn't add content type" do
      expect(result_type).to be_nil
    end
  end

  context 'string body' do
    let(:result) { process('{"a":1}')}

    it "doesn't change body" do
      expect(result_body).to eql '{"a":1}'
    end

    it "adds content type" do
      expect(result_type).to eql 'application/json'
    end
  end

  context "object body" do
    let(:result) { process({:a => 1})}

    it "encodes body" do
      expect(result_body).to eql '{"a":1}'
    end

    it "adds content type" do
      expect(result_type).to eql 'application/json'
    end
  end

  context "empty object body" do
    let(:result) { process({})}

    it "encodes body" do
      expect(result_body).to eql '{}'
    end

    it "adds content type" do
      expect(result_type).to eql 'application/json'
    end
  end

  context 'object body with json type' do
    let(:result) { process({:a => 1}, 'application/json; charset=utf-8')}

    it "encodes body" do
      expect(result_body).to eql '{"a":1}'
    end

    it "doesn't change content type" do
      expect(result_type).to eql 'application/json; charset=utf-8'
    end
  end
end # Github::Request::Jsonize
