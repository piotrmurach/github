# encoding: utf-8

require 'spec_helper'

describe Github::Client::Activity::Starring, '#unstar' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/user/starred/#{user}/#{repo}" }

  after { reset_authentication_for subject }

  context "user authenticated" do
    context "with correct information" do
      before do
        subject.oauth_token = OAUTH_TOKEN
        stub_delete("/user/starred/#{user}/#{repo}").
          with(:query => {:access_token => OAUTH_TOKEN}).
          to_return(:body => "", :status => 204, :headers => {})
      end

      it "should successfully unstar a repo" do
        subject.unstar user, repo
        a_delete(request_path).with(:query => {:access_token => OAUTH_TOKEN}).
          should have_been_made
      end
    end
  end

  context "user unauthenticated" do
    it "should fail" do
      stub_delete(request_path).to_return(:body => "", :status => 401, :headers => {})
      expect {
        subject.unstar user, repo
      }.to raise_error(Github::Error::Unauthorized)
    end
  end
end # unstar
