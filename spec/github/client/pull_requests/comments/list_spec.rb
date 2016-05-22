# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::PullRequests::Comments, '#list' do
  let(:repo) { 'github' }
  let(:user) { 'peter-murach' }
  let(:number) { 1 }

  before {
    stub_get(request_path).to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context 'on a pull request' do
    let(:request_path) { "/repos/#{user}/#{repo}/pulls/#{number}/comments" }
    let(:body) { fixture('pull_requests/comments.json') }
    let(:status) { 200 }

    it { should respond_to :all }

    it { expect { subject.list }.to raise_error(ArgumentError) }

    it "throws error if comment id not provided" do
      expect { subject.list user }.to raise_error(ArgumentError)
    end

    it "gets the resources" do
      subject.list user, repo, number: number
      expect(a_get(request_path)).to have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list user, repo, number: number }
    end

    it "gets pull request comment information" do
      comments = subject.list user, repo, number: number
      expect(comments.first.id).to eq(number)
    end

    it "yields to a block" do
      yielded = []
      result = subject.list(user, repo, number: number) {|obj| yielded << obj }
      expect(yielded).to eq(result)
    end
  end

  context 'in a repository' do
    let(:request_path) { "/repos/#{user}/#{repo}/pulls/comments" }
    let(:body) { fixture('pull_requests/comments.json') }
    let(:status) { 200 }

    it "gets the resources" do
      subject.list user, repo
      expect(a_get(request_path)).to have_been_made
    end

    it "gets pull request comment information" do
      comments = subject.list user, repo
      expect(comments.first.id).to eq(number)
    end

    it "yields to a block" do
      yielded = []
      result = subject.list(user, repo) { |obj| yielded << obj }
      expect(yielded).to eq(result)
    end

    it_should_behave_like 'request failure' do
      let(:requestable) { subject.list user, repo }
    end
  end
end # list
