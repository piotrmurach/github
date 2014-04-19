# encoding: utf-8

require 'spec_helper'

describe Github::Client::Issues::Milestones, '#get' do
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:milestone_id) { 1 }
  let(:request_path) { "/repos/#{user}/#{repo}/milestones/#{milestone_id}" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body) { fixture('issues/milestone.json') }
    let(:status) { 200 }

    it { subject.should respond_to :find }

    it { expect { subject.get }.to raise_error(ArgumentError) }

    it "should fail to get resource without milestone id" do
      expect { subject.get user, repo, nil }.to raise_error(ArgumentError)
    end

    it "should get the resource" do
      subject.get user, repo, milestone_id
      a_get(request_path).should have_been_made
    end

    it "should get milestone information" do
      milestone = subject.get user, repo, milestone_id
      milestone.number.should == milestone_id
      milestone.title.should == 'v1.0'
    end

    it "should return mash" do
      milestone = subject.get user, repo, milestone_id
      milestone.should be_a Github::ResponseWrapper
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get user, repo, milestone_id }
  end

end # get
