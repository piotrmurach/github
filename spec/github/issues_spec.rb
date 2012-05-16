# encoding: utf-8

require 'spec_helper'

describe Github::Issues do
  let(:issues_api) { Github::Issues }
  let(:github) { Github.new }
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:issue_id) { 1347 }

  after { reset_authentication_for github }

  context 'access to apis' do
    it { subject.comments.should be_a Github::Issues::Comments }
    it { subject.events.should be_a Github::Issues::Events }
    it { subject.labels.should be_a Github::Issues::Labels }
    it { subject.milestones.should be_a Github::Issues::Milestones }
  end

  context '#list' do
    it { github.issues.should respond_to(:all) }

    context "resource found" do
      before do
        stub_get("/issues").
          to_return(:body => fixture('issues/issues.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the resources" do
        github.issues.list
        a_get("/issues").should have_been_made
      end

      it "should return array of resources" do
        issues = github.issues.list
        issues.should be_an Array
        issues.should have(1).items
      end

      it "should be a mash type" do
        issues = github.issues.list
        issues.first.should be_a Hashie::Mash
      end

      it "should get issue information" do
        issues = github.issues.list
        issues.first.title.should == 'Found a bug'
      end

      it "should yield to a block" do
        github.issues.should_receive(:list).and_yield('web')
        github.issues.list { |param| 'web' }.should == 'web'
      end
    end

    context "resource not found" do
      before do
        stub_get("/issues").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect { github.issues.list }.to raise_error(Github::Error::NotFound)
      end
    end
  end # list

  describe '#list_repo' do
    it { github.issues.should respond_to :list_repository }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/issues").
          to_return(:body => fixture('issues/issues.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should raise error if user-name empty" do
        expect {
          github.issues.list_repo nil, repo
        }.should raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.issues.list_repo user, repo
        a_get("/repos/#{user}/#{repo}/issues").should have_been_made
      end

      it "should return array of resources" do
        repo_issues = github.issues.list_repo user, repo
        repo_issues.should be_an Array
        repo_issues.should have(1).items
      end

      it "should be a mash type" do
        repo_issues = github.issues.list_repo user, repo
        repo_issues.first.should be_a Hashie::Mash
      end

      it "should get repository issue information" do
        repo_issues = github.issues.list_repo user, repo
        repo_issues.first.title.should == 'Found a bug'
      end

      it "should yield to a block" do
        github.issues.should_receive(:list_repo).with(user, repo).and_yield('web')
        github.issues.list_repo(user, repo) { |param| 'web' }.should == 'web'
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/issues").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.issues.list_repo user, repo
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # list_repo

  describe "#get" do
    it { github.issues.should respond_to :find }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/issues/#{issue_id}").
          to_return(:body => fixture('issues/issue.json'),
          :status => 200,
          :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without issue id" do
        expect { github.issues.get(user, repo, nil)}.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.issues.get user, repo, issue_id
        a_get("/repos/#{user}/#{repo}/issues/#{issue_id}").should have_been_made
      end

      it "should get issue information" do
        issue = github.issues.get user, repo, issue_id
        issue.number.should == issue_id
        issue.title.should == 'Found a bug'
      end

      it "should return mash" do
        issue = github.issues.get user, repo, issue_id
        issue.should be_a Hashie::Mash
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/issues/#{issue_id}").
          to_return(:body => fixture('issues/issue.json'),
          :status => 404,
          :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.issues.get user, repo, issue_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # get_issue

  describe "#create" do
    let(:inputs) {
      {
         "title" =>  "Found a bug",
         "body" => "I'm having a problem with this.",
         "assignee" =>  "octocat",
         "milestone" => 1,
         "labels" => [
           "Label1",
           "Label2"
         ]
      }
    }
    context "resouce created" do
      before do
        stub_post("/repos/#{user}/#{repo}/issues").with(inputs).
          to_return(:body => fixture('issues/issue.json'), :status => 201, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to create resource if 'title' input is missing" do
        expect {
          github.issues.create user, repo, inputs.except('title')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should create resource successfully" do
        github.issues.create user, repo, inputs
        a_post("/repos/#{user}/#{repo}/issues").with(inputs).should have_been_made
      end

      it "should return the resource" do
        issue = github.issues.create user, repo, inputs
        issue.should be_a Hashie::Mash
      end

      it "should get the issue information" do
        issue = github.issues.create(user, repo, inputs)
        issue.title.should == 'Found a bug'
      end
    end

    context "failed to create resource" do
      before do
        stub_post("/repos/#{user}/#{repo}/issues").with(inputs).
          to_return(:body => fixture('issues/issue.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should faile to retrieve resource" do
        expect {
          github.issues.create user, repo, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # create

  describe "#edit" do
    let(:inputs) {
      {
         "title" =>  "Found a bug",
         "body" => "I'm having a problem with this.",
         "assignee" =>  "octocat",
         "milestone" => 1,
         "labels" => [
           "Label1",
           "Label2"
         ]
      }
    }

    context "resource edited successfully" do
      before do
        stub_patch("/repos/#{user}/#{repo}/issues/#{issue_id}").with(inputs).
          to_return(:body => fixture("issues/issue.json"), :status => 200, :headers => { :content_type => "application/json; charset=utf-8"})
      end

      it "should fail to edit without 'user/repo' parameters" do
        expect {
          github.issues.edit nil, repo, issue_id
        }.to raise_error(ArgumentError)
      end

      it "should edit the resource" do
        github.issues.edit user, repo, issue_id, inputs
        a_patch("/repos/#{user}/#{repo}/issues/#{issue_id}").with(inputs).should have_been_made
      end

      it "should return resource" do
        issue = github.issues.edit user, repo, issue_id, inputs
        issue.should be_a Hashie::Mash
      end

      it "should be able to retrieve information" do
        issue = github.issues.edit user, repo, issue_id, inputs
        issue.title.should == 'Found a bug'
      end
    end

    context "failed to edit resource" do
      before do
        stub_patch("/repos/#{user}/#{repo}/issues/#{issue_id}").with(inputs).
          to_return(:body => fixture("issues/issue.json"), :status => 404, :headers => { :content_type => "application/json; charset=utf-8"})
      end

      it "should fail to find resource" do
        expect {
          github.issues.edit user, repo, issue_id, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # edit_issue

end # Github::Issues
