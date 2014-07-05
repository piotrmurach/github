# encoding: utf-8

require 'spec_helper'

describe Github::Client::Issues::Milestones, '#create' do
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:number) { 1 }
  let(:request_path) { "/repos/#{user}/#{repo}/milestones/#{number}" }

  before {
    stub_delete(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce removed" do
    let(:body) { fixture('issues/milestone.json') }
    let(:status) { 201 }

    it "should remove resource successfully" do
      subject.delete user, repo, number
      a_delete(request_path).should have_been_made
    end

    it "should return the resource" do
      milestone = subject.delete user, repo, number
      milestone.should be_a Github::ResponseWrapper
    end

    it "should get the milestone information" do
      milestone = subject.delete user, repo, number
      milestone.title.should == 'v1.0'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.delete user, repo, number }
  end
end # delete
