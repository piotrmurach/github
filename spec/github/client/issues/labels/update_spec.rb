# encoding: utf-8

require 'spec_helper'

describe Github::Client::Issues::Labels, '#update' do
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:label_id) { 1 }
  let(:request_path) { "/repos/#{user}/#{repo}/labels/#{label_id}" }
  let(:inputs) {
    {
      "name" => "API",
      "color" => "FFFFFF",
    }
  }

  before {
    stub_patch(request_path).with(inputs).
      to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce updated" do
    let(:body) { fixture('issues/label.json') }
    let(:status) { 200 }

    it "should fail to create resource if 'name' input is missing" do
      expect {
        subject.update user, repo, label_id, inputs.except('name')
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should fail to create resource if 'color' input is missing" do
      expect {
        subject.update user, repo, label_id, inputs.except('color')
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should update resource successfully" do
      subject.update user, repo, label_id, inputs
      a_patch(request_path).with(inputs).should have_been_made
    end

    it "should return the resource" do
      label = subject.update user, repo, label_id, inputs
      label.should be_a Github::ResponseWrapper
    end

    it "should get the label information" do
      label = subject.update user, repo, label_id, inputs
      label.name.should == 'bug'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.update user, repo, label_id, inputs }
  end
end # update
