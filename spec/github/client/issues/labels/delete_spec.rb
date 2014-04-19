# encoding: utf-8

require 'spec_helper'

describe Github::Client::Issues::Labels, '#delete' do
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
    stub_delete(request_path).with(inputs).
      to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce removed" do
    let(:body) { fixture('issues/label.json') }
    let(:status) { 204 }

    it "should remove resource successfully" do
      subject.delete user, repo, label_id
      a_delete(request_path).should have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.delete user, repo, label_id }
  end
end # delete
