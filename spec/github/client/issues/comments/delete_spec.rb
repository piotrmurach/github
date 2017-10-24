# encoding: utf-8

require 'spec_helper'

describe Github::Client::Issues::Comments, '#delete' do
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:comment_id) { '1' }
  let(:request_path) { "/repos/#{user}/#{repo}/issues/comments/#{comment_id}" }

  before {
    stub_delete(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce deleted" do
    let(:body) { fixture('issues/comment.json') }
    let(:status) { 204 }

    it "should fail to delete resource if comment_id is missing" do
      expect { subject.delete user, repo, nil }.to raise_error(ArgumentError)
    end

    it "should create resource successfully" do
      subject.delete user, repo, comment_id
      a_delete(request_path).should have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.delete user, repo, comment_id }
  end
end # delete
