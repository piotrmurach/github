# encoding: utf-8

require 'spec_helper'

describe Github::PullRequests::Comments do
  let(:github) { Github.new }
  let(:user)   { 'peter-murach' }
  let(:repo) { 'github' }
  let(:pull_request_id) { 1 }
  let(:comment_id) { 1 }

  after { reset_authentication_for github }

  describe "#list" do
    it { github.pull_requests.comments.should respond_to :all }

    context 'resource found' do

      before do
        stub_get("/repos/#{user}/#{repo}/pulls/#{pull_request_id}/comments").
          to_return(:body => fixture('pull_requests/comments.json'),
            :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "throws error if comment id not provided" do
        expect {
          github.pull_requests.comments.list user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.pull_requests.comments.list user, repo, pull_request_id
        a_get("/repos/#{user}/#{repo}/pulls/#{pull_request_id}/comments").
          should have_been_made
      end

      it "should return array of resources" do
        comments = github.pull_requests.comments.list user, repo, pull_request_id
        comments.should be_an Array
        comments.should have(1).items
      end

      it "should be a mash type" do
        comments = github.pull_requests.comments.list user, repo, pull_request_id
        comments.first.should be_a Hashie::Mash
      end

      it "should get pull request comment information" do
        comments = github.pull_requests.comments.list user, repo, pull_request_id
        comments.first.id.should == pull_request_id
      end

      it "should yield to a block" do
        github.pull_requests.comments.should_receive(:list).
          with(user, repo, pull_request_id).and_yield('web')
        github.pull_requests.comments.list(user, repo, pull_request_id) {|param| 'web' }
      end
    end

    context 'resource not found' do
      before do
        stub_get("/repos/#{user}/#{repo}/pulls/#{pull_request_id}/comments").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.pull_requests.comments.list user, repo, pull_request_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # list

  describe "#get" do
    it { github.pull_requests.comments.should respond_to :find }

    context 'resource found' do
      before do
        stub_get("/repos/#{user}/#{repo}/pulls/comments/#{comment_id}").
          to_return(:body => fixture('pull_requests/comment.json'),
          :status => 200,
          :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without comment id" do
        expect {
          github.pull_requests.comments.get user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.pull_requests.comments.get user, repo, pull_request_id
        a_get("/repos/#{user}/#{repo}/pulls/comments/#{comment_id}").
          should have_been_made
      end

      it "should get comment information" do
        comment = github.pull_requests.comments.get user, repo, comment_id
        comment.id.should eq comment_id
        comment.user.login.should == 'octocat'
      end

      it "should return mash" do
        comment = github.pull_requests.comments.get user, repo, comment_id
        comment.should be_a Hashie::Mash
      end
    end

    context 'resource not found' do
      before do
        stub_get("/repos/#{user}/#{repo}/pulls/comments/#{comment_id}").
          to_return(:body => fixture('pull_requests/comment.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.pull_requests.comments.get user, repo, comment_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # get

  describe "#create" do
    let(:inputs) {
      {
        "body" => "Nice change",
        "commit_id" => "6dcb09b5b57875f334f61aebed695e2e4193db5e",
        "path" => "file1.txt",
        "position" => 4,
        "in_reply_to" => 4,
        'unrelated' => 'giberrish'
      }
    }

    context "resouce created" do
      before do
        stub_post("/repos/#{user}/#{repo}/pulls/#{pull_request_id}/comments").
          with(inputs.except('unrelated')).
          to_return(:body => fixture('pull_requests/comment.json'), :status => 201, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it 'raises error when pull_request_id is missing' do
        expect {
          github.pull_requests.comments.create user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should create resource successfully" do
        github.pull_requests.comments.create user, repo, pull_request_id, inputs
        a_post("/repos/#{user}/#{repo}/pulls/#{pull_request_id}/comments").
          with(inputs).should have_been_made
      end

      it "should return the resource" do
        pull_request = github.pull_requests.comments.create user, repo, pull_request_id, inputs
        pull_request.should be_a Hashie::Mash
      end

      it "should get the request information" do
        pull_request = github.pull_requests.comments.create user, repo, pull_request_id, inputs
        pull_request.id.should == pull_request_id
      end
    end

    context "fails to create resource" do
      before do
        stub_post("/repos/#{user}/#{repo}/pulls/#{pull_request_id}/comments").
          with(inputs.except('unrelated')).
          to_return(:body => fixture('pull_requests/comment.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should faile to retrieve resource" do
        expect {
          github.pull_requests.comments.create user, repo, pull_request_id, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # create

  describe "#edit" do
    let(:inputs) {
      {
        "body" => "Nice change",
        'unrelated' => 'giberrish'
      }
    }

    context "resouce edited" do
      before do
        stub_patch("/repos/#{user}/#{repo}/pulls/comments/#{comment_id}").
          with(inputs.except('unrelated')).
          to_return(:body => fixture('pull_requests/comment.json'),
                :status => 200,
                :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should edit resource successfully" do
        github.pull_requests.comments.edit user, repo, comment_id, inputs
        a_patch("/repos/#{user}/#{repo}/pulls/comments/#{comment_id}").
          with(inputs).should have_been_made
      end

      it "should return the resource" do
        comment = github.pull_requests.comments.edit user, repo, comment_id, inputs
        comment.should be_a Hashie::Mash
      end

      it "should get the comment information" do
        comment = github.pull_requests.comments.edit user, repo, comment_id, inputs
        comment.user.login.should == 'octocat'
      end
    end

    context "failed to edit resource" do
      before do
        stub_patch("/repos/#{user}/#{repo}/pulls/comments/#{comment_id}").
          with(inputs).
          to_return(:body => fixture('pull_requests/comment.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrieve resource" do
        expect {
          github.pull_requests.comments.edit user, repo, comment_id, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # edit

  context "#delete" do
    before do
      stub_delete("/repos/#{user}/#{repo}/pulls/comments/#{comment_id}").
        to_return(:body => fixture('pull_requests/comment.json'),
              :status => 204,
              :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it 'should raise error if comment_id not present' do
      expect {
        github.pull_requests.comments.delete user, repo, nil
      }.to raise_error(ArgumentError)
    end

    it "should remove resource successfully" do
      github.pull_requests.comments.delete user, repo, comment_id
      a_delete("/repos/#{user}/#{repo}/pulls/comments/#{comment_id}").
        should have_been_made
    end

    it "fails to delete resource" do
      stub_delete("/repos/#{user}/#{repo}/pulls/comments/#{comment_id}").
        to_return(:body => '',
          :status => 404,
          :headers => {:content_type => "application/json; charset=utf-8"})
      expect {
        github.pull_requests.comments.delete user, repo, comment_id
      }.to raise_error(Github::Error::NotFound)
    end
  end # delete

end # Github::PullRequests::Comments
