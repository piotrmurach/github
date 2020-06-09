# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::PullRequests, '#list' do
  let(:repo) { 'github' }
  let(:user) { 'peter-murach' }
  let(:inputs) { { 'state'=> 'closed' } }
  let(:request_path) { "/repos/#{user}/#{repo}/pulls" }

  before {
    stub_get(request_path).with(query: inputs).
    to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context 'resource found' do
    let(:body) { fixture('pull_requests/pull_requests.json') }
    let(:status) { 200 }

    it { is_expected.to respond_to :all }

    it { expect { subject.list }.to raise_error(ArgumentError) }

    it { expect { subject.list user }.to raise_error(ArgumentError) }

    it "gets the resources" do
      subject.list user, repo, inputs
      expect(a_get(request_path).with(query: inputs)).to have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list user, repo, inputs }
    end

    it "gets pull request information" do
      pull_requests = subject.list user, repo, inputs
      expect(pull_requests.first.title).to eq('new-feature')
    end

    it "yields to a block" do
      yielded = []
      result = subject.list(user, repo, inputs) { |obj| yielded << obj }
      expect(yielded).to eq(result)
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.list user, repo, inputs }
  end
end # list
