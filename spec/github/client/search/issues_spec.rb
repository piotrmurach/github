# encoding: utf-8

require 'spec_helper'

describe Github::Client::Search, '#issues' do
  let(:query)        { 'tty' }
  let(:request_path) { "/search/issues" }

  before {
    stub_get(request_path).with(query: {q: query}).
      to_return(body: body, status: status,
      headers: {content_type: 'application/json; charset=utf-8'})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body)   { fixture('search/issues.json') }
    let(:status) { 200 }

    it { should respond_to :issues }

    it "should get the resources" do
      subject.issues q: query
      a_get(request_path).with(query: {q: query}).should have_been_made
    end

    it "should be a response wrapper" do
      code = subject.issues q: query
      code.should be_a Github::ResponseWrapper
    end

    it "should get information" do
      code = subject.issues q: query
      code.total_count.should == 280
    end
  end
end
