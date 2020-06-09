# encoding: utf-8

require 'spec_helper'

describe Github::Client::Search, '#users' do
  let(:query)        { 'tty' }
  let(:request_path) { "/search/users" }

  before {
    stub_get(request_path).with(query: {q: query}).
      to_return(body: body, status: status,
      headers: {content_type: 'application/json; charset=utf-8'})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body)   { fixture('search/users.json') }
    let(:status) { 200 }

    it { is_expected.to respond_to :users }

    it "should get the resources" do
      subject.users q: query
      expect(a_get(request_path).with(query: {q: query})).to have_been_made
    end

    it "is_expected.to be a response wrapper" do
      code = subject.users q: query
      expect(code).to be_a Github::ResponseWrapper
    end

    it "should get information" do
      code = subject.users q: query
      expect(code.total_count).to eq 12
    end
  end
end
