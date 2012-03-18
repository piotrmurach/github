# encoding: utf-8

require 'spec_helper'

describe Github::Issues::Comments do
  let(:github) { Github.new }
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let!(:comment_id) { 1 }
  let!(:issue_id) { 1 }

  after { github.user, github.repo, github.oauth_token = nil, nil, nil }

  it { described_class::VALID_ISSUE_COMMENT_PARAM_NAME.should_not be_nil }

  describe '#list' do
    it { github.issues.should respond_to :all }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/issues/#{issue_id}/comments").
          to_return(:body => fixture('issues/comments.json'),
            :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without username" do
        expect {
          github.issues.comments.list user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.issues.comments.list user, repo, issue_id
        a_get("/repos/#{user}/#{repo}/issues/#{issue_id}/comments").should have_been_made
      end

      it "should return array of resources" do
        comments = github.issues.comments.list user, repo, issue_id
        comments.should be_an Array
        comments.should have(1).items
      end

      it "should be a mash type" do
        comments = github.issues.comments.list user, repo, issue_id
        comments.first.should be_a Hashie::Mash
      end

      it "should get issue comment information" do
        comments = github.issues.comments.list user, repo, issue_id
        comments.first.user.login.should == 'octocat'
      end

      it "should yield to a block" do
        github.issues.comments.should_receive(:list).
          with(user, repo, issue_id).and_yield('web')
        github.issues.comments.list(user, repo, issue_id) { |param| 'web' }.
          should == 'web'
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/issues/#{issue_id}/comments").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.issues.comments.list user, repo, issue_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # list

  describe "#get" do
    it { github.issues.comments.should respond_to :find }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/issues/comments/#{comment_id}").
          to_return(:body => fixture('issues/comment.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without comment id" do
        expect {
          github.issues.comments.get user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.issues.comments.get user, repo, comment_id
        a_get("/repos/#{user}/#{repo}/issues/comments/#{comment_id}").should have_been_made
      end

      it "should get comment information" do
        comment = github.issues.comments.get user, repo, comment_id
        comment.user.id.should == comment_id
        comment.user.login.should == 'octocat'
      end

      it "should return mash" do
        comment = github.issues.comments.get user, repo, comment_id
        comment.should be_a Hashie::Mash
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/issues/comments/#{comment_id}").
          to_return(:body => fixture('issues/comment.json'),
          :status => 404,
          :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.issues.comments.get user, repo, comment_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # get

  describe "#create" do
    let(:issue_id) { 1 }
    let(:inputs) { { 'body' => 'a new comment' } }

    context "resouce created" do
      before do
        stub_post("/repos/#{user}/#{repo}/issues/#{issue_id}/comments").
          with(:body => inputs).
          to_return(:body => fixture('issues/comment.json'),
          :status => 201,
          :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to create resource if 'body' input is missing" do
        expect {
          github.issues.comments.create user, repo, issue_id, inputs.except('body')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should create resource successfully" do
        github.issues.comments.create user, repo, issue_id, inputs
        a_post("/repos/#{user}/#{repo}/issues/#{issue_id}/comments").
          with(inputs).should have_been_made
      end

      it "should return the resource" do
        comment = github.issues.comments.create user, repo, issue_id, inputs
        comment.should be_a Hashie::Mash
      end

      it "should get the comment information" do
        comment = github.issues.comments.create user, repo, issue_id, inputs
        comment.user.login.should == 'octocat'
      end
    end

    context "failed to create resource" do
      before do
        stub_post("/repos/#{user}/#{repo}/issues/#{issue_id}/comments").
          with(inputs).
          to_return(:body => fixture('issues/comment.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrieve resource" do
        expect {
          github.issues.comments.create user, repo, issue_id, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # create

  describe "edit_comment" do
    let(:comment_id) { 1 }
    let(:inputs) { { 'body' => 'a new comment' } }

    context "resouce edited" do
      before do
        stub_patch("/repos/#{user}/#{repo}/issues/comments/#{comment_id}").
          with(inputs).
          to_return(:body => fixture('issues/comment.json'),
            :status => 201,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to create resource if 'body' input is missing" do
        expect {
          github.issues.comments.edit user, repo, comment_id, inputs.except('body')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should create resource successfully" do
        github.issues.comments.edit user, repo, comment_id, inputs
        a_patch("/repos/#{user}/#{repo}/issues/comments/#{comment_id}").
          with(inputs).should have_been_made
      end

      it "should return the resource" do
        comment = github.issues.comments.edit user, repo, comment_id, inputs
        comment.should be_a Hashie::Mash
      end

      it "should get the comment information" do
        comment = github.issues.comments.edit user, repo, comment_id, inputs
        comment.user.login.should == 'octocat'
      end
    end

    context "failed to create resource" do
      before do
        stub_patch("/repos/#{user}/#{repo}/issues/comments/#{comment_id}").
          with(inputs).
          to_return(:body => fixture('issues/comment.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrieve resource" do
        expect {
          github.issues.comments.edit user, repo, comment_id, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # edit

  describe "#delete" do
    let(:comment_id) { 1 }

    context "resouce deleted" do
      before do
        stub_delete("/repos/#{user}/#{repo}/issues/comments/#{comment_id}").
          to_return(:body => fixture('issues/comment.json'),
            :status => 204,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to delete resource if comment_id is missing" do
        expect {
          github.issues.comments.delete user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should create resource successfully" do
        github.issues.comments.delete user, repo, comment_id
        a_delete("/repos/#{user}/#{repo}/issues/comments/#{comment_id}").
          should have_been_made
      end
    end

    context "failed to create resource" do
      before do
        stub_delete("/repos/#{user}/#{repo}/issues/comments/#{comment_id}").
          to_return(:body => fixture('issues/comment.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrieve resource" do
        expect {
          github.issues.comments.delete user, repo, comment_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # delete

end # Github::Issues::Comments
