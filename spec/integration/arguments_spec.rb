# encoding: utf-8

require 'spec_helper'

describe 'Arguments' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github-api' }
  let(:api)  { Github::Issues.new :user => user, :repo => repo }
  let(:body) { '[]' }
  let(:status) { 200 }

  subject { api.milestones }

  context 'with existing arguments' do
    let(:request_path) { "/repos/#{user}/#{repo}/milestones" }

    before {
      stub_get(request_path).to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
    }

    it { subject.user.should == user }

    it { subject.repo.should == repo }

    it 'performs request' do
      subject.list nil, nil
      a_get(request_path).should have_been_made
    end

    it "does not set argument to nil" do
      subject.list nil, nil
      subject.user.should == user
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

    it {
      subject.get nil, nil, milestone_id
      a_get(request_path).should have_been_made
    }

    it 'creates setter' do
      subject.get nil, nil, milestone_id
      subject.milestone_id.should == milestone_id
    end
  end
end
