# encoding: utf-8

require 'spec_helper'

describe Github::Issues::Milestones do
  let(:github) { Github.new }
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }

  after { reset_authentication_for github }

  it { described_class::VALID_MILESTONE_OPTIONS.should_not be_nil }
  it { described_class::VALID_MILESTONE_INPUTS.should_not be_nil }

  describe '#list' do
    it { github.issues.milestones.should respond_to :all }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/milestones").
          to_return(:body => fixture('issues/milestones.json'),
            :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without username" do
        expect {
          github.issues.milestones.list nil, repo
        }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.issues.milestones.list user, repo
        a_get("/repos/#{user}/#{repo}/milestones").should have_been_made
      end

      it "should return array of resources" do
        milestones = github.issues.milestones.list user, repo
        milestones.should be_an Array
        milestones.should have(1).items
      end

      it "should be a mash type" do
        milestones = github.issues.milestones.list user, repo
        milestones.first.should be_a Hashie::Mash
      end

      it "should get issue information" do
        milestones = github.issues.milestones.list user, repo
        milestones.first.title.should == 'v1.0'
      end

      it "should yield to a block" do
        github.issues.milestones.should_receive(:list).
          with(user, repo).and_yield('web')
        github.issues.milestones.list(user, repo) { |param| 'web' }.should == 'web'
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/milestones").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.issues.milestones.list user, repo
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # list

  describe "#get" do
    let(:milestone_id) { 1 }

    it { github.issues.milestones.should respond_to :find }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/milestones/#{milestone_id}").
          to_return(:body => fixture('issues/milestone.json'),
            :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without milestone id" do
        expect {
          github.issues.milestones.get user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.issues.milestones.get user, repo, milestone_id
        a_get("/repos/#{user}/#{repo}/milestones/#{milestone_id}").should have_been_made
      end

      it "should get milestone information" do
        milestone = github.issues.milestones.get user, repo, milestone_id
        milestone.number.should == milestone_id
        milestone.title.should == 'v1.0'
      end

      it "should return mash" do
        milestone = github.issues.milestones.get user, repo, milestone_id
        milestone.should be_a Hashie::Mash
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/milestones/#{milestone_id}").
          to_return(:body => fixture('issues/milestone.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.issues.milestones.get user, repo, milestone_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # get

  describe "create_milestone" do
    let(:inputs) {
      {
        "title" => "String",
        "state" => "open or closed",
        "description" => "String",
        "due_on" => "Time"
      }
    }

    context "resouce created" do
      before do
        stub_post("/repos/#{user}/#{repo}/milestones").with(inputs).
          to_return(:body => fixture('issues/milestone.json'),
            :status => 201,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to create resource if 'title' input is missing" do
        expect {
          github.issues.milestones.create user, repo, inputs.except('title')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should create resource successfully" do
        github.issues.milestones.create user, repo, inputs
        a_post("/repos/#{user}/#{repo}/milestones").with(inputs).should have_been_made
      end

      it "should return the resource" do
        milestone = github.issues.milestones.create user, repo, inputs
        milestone.should be_a Hashie::Mash
      end

      it "should get the milestone information" do
        milestone = github.issues.milestones.create user, repo, inputs
        milestone.title.should == 'v1.0'
      end
    end

    context "failed to create resource" do
      before do
        stub_post("/repos/#{user}/#{repo}/milestones").with(inputs).
          to_return(:body => fixture('issues/milestone.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should faile to retrieve resource" do
        expect {
          github.issues.milestones.create user, repo, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # create

  describe "#update" do
    let(:milestone_id) { 1 }
    let(:inputs) {
      {
        "title" => "String",
        "state" => "open or closed",
        "description" => "String",
        "due_on" => "Time"
      }
    }

    context "resouce updated" do
      before do
        stub_patch("/repos/#{user}/#{repo}/milestones/#{milestone_id}").
          with(inputs).
          to_return(:body => fixture('issues/milestone.json'), :status => 201, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to create resource if 'title' input is missing" do
        expect {
          github.issues.milestones.update user, repo, milestone_id, inputs.except('title')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should update resource successfully" do
        github.issues.milestones.update user, repo, milestone_id, inputs
        a_patch("/repos/#{user}/#{repo}/milestones/#{milestone_id}").
          with(inputs).should have_been_made
      end

      it "should return the resource" do
        milestone = github.issues.milestones.update user, repo, milestone_id, inputs
        milestone.should be_a Hashie::Mash
      end

      it "should get the milestone information" do
        milestone = github.issues.milestones.update user, repo, milestone_id, inputs
        milestone.title.should == 'v1.0'
      end
    end

    context "failed to create resource" do
      before do
        stub_patch("/repos/#{user}/#{repo}/milestones/#{milestone_id}").
          with(inputs).
          to_return(:body => fixture('issues/milestone.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should faile to retrieve resource" do
        expect {
          github.issues.milestones.update user, repo, milestone_id, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # update

  describe "#delete" do
    let(:milestone_id) { 1 }

    context "resouce removed" do
      before do
        stub_delete("/repos/#{user}/#{repo}/milestones/#{milestone_id}").
          to_return(:body => fixture('issues/milestone.json'),
            :status => 201,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should remove resource successfully" do
        github.issues.milestones.delete user, repo, milestone_id
        a_delete("/repos/#{user}/#{repo}/milestones/#{milestone_id}").
          should have_been_made
      end

      it "should return the resource" do
        milestone = github.issues.milestones.delete user, repo, milestone_id
        milestone.should be_a Hashie::Mash
      end

      it "should get the milestone information" do
        milestone = github.issues.milestones.delete user, repo, milestone_id
        milestone.title.should == 'v1.0'
      end
    end

    context "failed to remove resource" do
      before do
        stub_delete("/repos/#{user}/#{repo}/milestones/#{milestone_id}").
          to_return(:body => fixture('issues/milestone.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should faile to retrieve resource" do
        expect {
          github.issues.milestones.delete user, repo, milestone_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # delete

end # Github::Issues::Milestones
