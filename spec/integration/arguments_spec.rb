# encoding: utf-8

require 'spec_helper'

describe 'Arguments' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github-api' }
  let(:api)  { Github::Client::Issues.new user: user, repo: repo }
  let(:body) { '[]' }
  let(:status) { 200 }

  subject { api.milestones }

  context 'with existing arguments' do
    let(:request_path) { "/repos/#{user}/#{repo}/milestones" }

    before {
      stub_get(request_path).to_return(body: body, status: status,
        headers: {content_type: "application/json; charset=utf-8"})
    }

    it { expect(subject.user).to eq user }

    it { expect(subject.repo).to eq repo }

    it 'performs request' do
      subject.list
      a_get(request_path).should have_been_made
    end

    it "does not set argument to nil" do
      subject.list
      expect(subject.user).to eq user
    end
  end

  context 'with new arguments' do
    let(:milestone_id) { 11 }
    let(:request_path) { "/repos/#{user}/#{repo}/milestones/#{milestone_id}" }

    before {
      stub_get(request_path).to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
    }

    it { expect { subject.milestone_id }.to raise_error(NoMethodError) }

    it "performs request" do
      subject.get user, repo, milestone_id
      expect(a_get(request_path)).to have_been_made
    end

    it 'reads user & repo settings' do
      subject.get number: milestone_id
      expect(a_get(request_path)).to have_been_made
    end

    it 'reads user & repo and requires milestone_id' do
      expect { subject.get milestone_id }.to raise_error(ArgumentError)
    end

    it 'requires extra parameter' do
      expect { subject.get user, repo }.to raise_error(ArgumentError)
    end

    it 'requires milestone_id to be set' do
      expect { subject.get }.to raise_error(ArgumentError)
    end

    it "passes through extra parameters" do
      subject.get user, repo, milestone_id, :auto_pagination => true
    end
  end
end
