# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Gists, '#get' do
  let(:gist_id) { 1 }

  before {
    stub_get(request_path).to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:request_path) { "/gists/#{gist_id}" }
    let(:body) { fixture('gists/gist.json') }
    let(:status) { 200 }

    it { is_expected.to respond_to :find }

    it "fails to get resource without gist id" do
      expect { subject.get }.to raise_error(ArgumentError)
    end

    it "gets the resource" do
      subject.get gist_id
      expect(a_get(request_path)).to have_been_made
    end

    it "gets gist information" do
      gist = subject.get gist_id
      expect(gist.id.to_i).to eq gist_id
      expect(gist.user.login).to eq('octocat')
    end

    it "returns response wrapper" do
      gist = subject.get(gist_id)
      expect(gist).to be_a(Github::ResponseWrapper)
    end

    it_should_behave_like 'request failure' do
      let(:requestable) { subject.get gist_id }
    end
  end

  context 'resource found with sha' do
    let(:sha) { 'aa5a315d61ae9438b18d' }
    let(:request_path) { "/gists/#{gist_id}/#{sha}" }
    let(:body) { fixture('gists/gist.json') }
    let(:status) { 200 }

    it "gets the resource" do
      subject.get(gist_id, sha: sha)
      expect(a_get(request_path)).to have_been_made
    end
  end
end # get
