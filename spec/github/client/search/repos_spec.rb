# encoding: utf-8

require 'spec_helper'

describe Github::Client::Search, '#repos' do
  let(:query)        { 'tty' }
  let(:request_path) { "/search/repositories" }

  before {
    stub_get(request_path).with(query: {q: query}).
      to_return(body: body, status: status,
      headers: {content_type: 'application/json; charset=utf-8'})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body)   { fixture('search/repos.json') }
    let(:status) { 200 }

    it { should respond_to :repos }

    it "should get the resources" do
      subject.repos q: query
      a_get(request_path).with(query: {q: query}).should have_been_made
    end

    it "should be a response wrapper" do
      code = subject.repos q: query
      code.should be_a Github::ResponseWrapper
    end

    it "should get information" do
      code = subject.repos q: query
      code.total_count.should == 40
    end
  end
end
