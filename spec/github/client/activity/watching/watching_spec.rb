# encoding: utf-8

require 'spec_helper'

describe Github::Client::Activity::Watching, '#watching?' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/user/subscriptions/#{user}/#{repo}" }

  after { reset_authentication_for subject }

  context "with username ane reponame passed" do
    context "this repo is being watched by the user"
      before do
        stub_get(request_path).
          to_return(:body => "[]", :status => 404,
                    :headers => {:user_agent => subject.user_agent})
      end

    it "should return false if resource not found" do
      watching = subject.watching? user, repo
      watching.should be_false
    end

    it "should return true if resoure found" do
        stub_get(request_path).
          to_return(:body => "[]", :status => 200,
            :headers => {:user_agent => subject.user_agent})
      watching = subject.watching? user, repo
      watching.should be_true
    end
  end

  context "without username and reponame passed" do
    it "should fail validation " do
      expect { subject.watching? user, nil }.to raise_error(ArgumentError)
    end
  end
end # watching?
