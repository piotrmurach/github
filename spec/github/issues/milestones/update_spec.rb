# encoding: utf-8

require 'spec_helper'

describe Github::Issues::Milestones, '#update' do
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:milestone_id) { 1 }
  let(:request_path) { "/repos/#{user}/#{repo}/milestones/#{milestone_id}" }
  let(:inputs) {
    {
      "title" => "String",
      "state" => "open or closed",
      "description" => "String",
      "due_on" => "Time"
    }
  }

  before {
    stub_patch(request_path).with(inputs).
      to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce updated" do
    let(:body) { fixture('issues/milestone.json') }
    let(:status) { 201 }

    it "should fail to create resource if 'number' input is missing" do
      expect {
        subject.update user, repo, nil, inputs
      }.to raise_error(ArgumentError)
    end

    it "should update resource successfully" do
      subject.update user, repo, milestone_id, inputs
      a_patch(request_path).with(inputs).should have_been_made
    end

    it "should return the resource" do
      milestone = subject.update user, repo, milestone_id, inputs
      milestone.should be_a Github::ResponseWrapper
    end

    it "should get the milestone information" do
      milestone = subject.update user, repo, milestone_id, inputs
      milestone.title.should == 'v1.0'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.update user, repo, milestone_id, inputs }
  end

end # update
