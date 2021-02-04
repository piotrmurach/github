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
    stub_patch(request_path).with(body: inputs).
      to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce updated" do
    let(:body) { fixture('issues/label.json') }
    let(:status) { 200 }

    it "should update resource successfully" do
      subject.update user, repo, label_id, inputs
      expect(a_patch(request_path).with(body: inputs)).to have_been_made
    end

    it "should return the resource" do
      label = subject.update user, repo, label_id, inputs
      expect(label).to be_a Github::ResponseWrapper
    end

    it "should get the label information" do
      label = subject.update user, repo, label_id, inputs
      expect(label.name).to eq 'bug'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.update user, repo, label_id, inputs }
  end
end # update
