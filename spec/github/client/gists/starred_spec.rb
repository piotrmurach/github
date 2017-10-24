# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Gists, '#starred' do
  let(:request_path) { "/gists/starred" }

  before {
    stub_get(request_path).to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body) { fixture('gists/gists.json') }
    let(:status) { 200 }

    it "gets the resources" do
      subject.starred
      expect(a_get(request_path)).to have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.starred }
    end

    it "gets gist information" do
      gists = subject.starred
      expect(gists.first.user.login).to eq('octocat')
    end

    it "yields to a block" do
        yielded = []
        result = subject.starred { |obj| yielded << obj }
        expect(yielded).to eq(result)
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.starred }
  end
end # starred
