# encoding: utf-8

require 'spec_helper'

describe Github::Gists::Comments do
  let(:github) { Github.new }
  let(:gist_id)    { '1' }
  let(:comment_id) { 1 }

  after { reset_authentication_for(github) }

  describe "#list" do
    it { github.gists.comments.should respond_to :all }

    context 'resource found' do
      before do
        stub_get("/gists/#{gist_id}/comments").
          to_return(:body => fixture('gists/comments.json'),
            :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "throws error if gist id not provided" do
        expect { github.gists.comments.list nil}.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.gists.comments.list gist_id
        a_get("/gists/#{gist_id}/comments").should have_been_made
      end

      it "should return array of resources" do
        comments = github.gists.comments.list gist_id
        comments.should be_an Array
        comments.should have(1).items
      end

      it "should be a mash type" do
        comments = github.gists.comments.list gist_id
        comments.first.should be_a Hashie::Mash
      end

      it "should get gist information" do
        comments = github.gists.comments.list gist_id
        comments.first.user.login.should == 'octocat'
      end

      it "should yield to a block" do
        github.gists.comments.should_receive(:list).with(gist_id).and_yield('web')
        github.gists.comments.list(gist_id) { |param| 'web' }
      end
    end

    context 'resource not found' do
      before do
        stub_get("/gists/#{gist_id}/comments").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.gists.comments.list gist_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # list

  describe "#get" do
    it { github.gists.should respond_to :find }

    context 'resource found' do
      before do
        stub_get("/gists/comments/#{comment_id}").
          to_return(:body => fixture('gists/comment.json'),
          :status => 200,
          :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without comment id" do
        expect { github.gists.comments.get nil }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.gists.comments.get comment_id
        a_get("/gists/comments/#{comment_id}").should have_been_made
      end

      it "should get comment information" do
        comment = github.gists.comments.get comment_id
        comment.id.should eq comment_id
        comment.user.login.should == 'octocat'
      end

      it "should return mash" do
        comment = github.gists.comments.get comment_id
        comment.should be_a Hashie::Mash
      end
    end

    context 'resource not found' do
      before do
        stub_get("/gists/comments/#{comment_id}").
          to_return(:body => fixture('gists/comment.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.gists.comments.get comment_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # get

  describe "#create" do
    let(:inputs) {
      { "body" =>"Just commenting for the sake of commenting", "unrelated" => true }
    }

    context "resouce created" do
      before do
        stub_post("/gists/#{gist_id}/comments").
          with(inputs.except('unrelated')).
          to_return(:body => fixture('gists/comment.json'),
                :status => 201,
                :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to create resource if 'content' input is missing" do
        expect {
          github.gists.comments.create gist_id, inputs.except('body')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should create resource successfully" do
        github.gists.comments.create gist_id, inputs
        a_post("/gists/#{gist_id}/comments").with(inputs).should have_been_made
      end

      it "should return the resource" do
        comment = github.gists.comments.create gist_id, inputs
        comment.should be_a Hashie::Mash
      end

      it "should get the comment information" do
        comment = github.gists.comments.create gist_id, inputs
        comment.user.login.should == 'octocat'
      end
    end

    context "failed to create resource" do
      before do
        stub_post("/gists/#{gist_id}/comments").with(inputs).
          to_return(:body => fixture('gists/comment.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should faile to retrieve resource" do
        expect {
          github.gists.comments.create gist_id, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # create

  describe "#edit" do
    let(:inputs) {
      { "body" =>"Just commenting for the sake of commenting", "unrelated" => true }
    }

    context "resouce edited" do
      before do
        stub_patch("/gists/comments/#{comment_id}").
          with(inputs.except('unrelated')).
          to_return(:body => fixture('gists/comment.json'),
                :status => 201,
                :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to create resource if 'content' input is missing" do
        expect {
          github.gists.comments.edit comment_id, inputs.except('body')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should create resource successfully" do
        github.gists.comments.edit comment_id, inputs
        a_patch("/gists/comments/#{comment_id}").with(inputs).should have_been_made
      end

      it "should return the resource" do
        comment = github.gists.comments.edit comment_id, inputs
        comment.should be_a Hashie::Mash
      end

      it "should get the comment information" do
        comment = github.gists.comments.edit comment_id, inputs
        comment.user.login.should == 'octocat'
      end
    end

    context "failed to create resource" do
      before do
        stub_patch("/gists/comments/#{comment_id}").with(inputs).
          to_return(:body => fixture('gists/comment.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should faile to retrieve resource" do
        expect {
          github.gists.comments.edit comment_id, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # edit

  describe "#delete" do
    context "resouce deleted" do
      before do
        stub_delete("/gists/comments/#{comment_id}").
          to_return(:body => '',
                :status => 204,
                :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to create resource if 'content' input is missing" do
        expect { github.gists.comments.delete nil }.to raise_error(ArgumentError)
      end

      it "should create resource successfully" do
        github.gists.comments.delete comment_id
        a_delete("/gists/comments/#{comment_id}").should have_been_made
      end
    end

    context "failed to create resource" do
      before do
        stub_delete("/gists/comments/#{comment_id}").
          to_return(:body => fixture('gists/comment.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should faile to retrieve resource" do
        expect {
          github.gists.comments.delete comment_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # delete

end # Github::Gists::Comments
