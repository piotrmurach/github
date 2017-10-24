# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Activity::Starring, '#list' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/stargazers" }

  after { reset_authentication_for subject }

  before {
    stub_get(request_path).
      to_return(body: body, status: status, headers: {})
  }

  context 'resource found' do
    let(:body) { fixture("repos/stargazers.json") }
    let(:status) { 200 }

    it { should respond_to :all }

    it { expect { subject.list user }.to raise_error(ArgumentError) }

    it "fails to get resource without username" do
      expect { subject.list }.to raise_error(ArgumentError)
    end

    it "yields iterator if block given" do
      yielded = []
      result = subject.list(user, repo) { |obj| yielded << obj }
      expect(yielded).to eq(result)
    end

    it "gets the resources" do
      subject.list user, repo
      expect(a_get(request_path)).to have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list user, repo }
    end

    it "gets watcher information" do
      stargazers = subject.list user, repo
      expect(stargazers.first.login).to eq('octocat')
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.list user, repo }
  end
end # list
