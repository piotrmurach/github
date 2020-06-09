# encoding: utf-8

require 'spec_helper'

describe Github::Client::Search::Legacy, '#repos' do
  let(:keyword)      { 'api' }
  let(:request_path) { "/legacy/repos/search/#{keyword}" }

  before do
    stub_get(request_path).
      to_return(body: body, status: status,
        headers: {content_type: "application/json; charset=utf-8"})
  end

  context "resource found" do
    let(:body)   { fixture('search/repos_legacy.json') }
    let(:status) { 200 }

    it { expect { subject.repos }.to raise_error(ArgumentError) }

    it "should get the resources" do
      subject.repos keyword
      expect(a_get(request_path)).to have_been_made
    end

    it "should get the resource through params hash" do
      subject.repos keyword: keyword
      expect(a_get(request_path)).to have_been_made
    end

    it "should get repository information" do
      repos = subject.repos keyword: keyword
      expect(repos.repositories.first.username).to eq 'mathiasbynens'
    end
  end
end
