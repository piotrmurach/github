require 'spec_helper'

describe Github::Issues::Labels do
  let(:github) { Github.new }
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:label_id) { 1 }

  after { github.user, github.repo, github.oauth_token = nil, nil, nil }

  it { described_class::VALID_LABEL_INPUTS.should_not be_nil }

  describe '#list' do
    it { github.issues.should respond_to :all }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/labels").
          to_return(:body => fixture('issues/labels.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without username" do
        expect {
          github.issues.labels.list nil, repo
        }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.issues.labels.list user, repo
        a_get("/repos/#{user}/#{repo}/labels").should have_been_made
      end

      it "should return array of resources" do
        labels = github.issues.labels.list user, repo
        labels.should be_an Array
        labels.should have(1).items
      end

      it "should be a mash type" do
        labels = github.issues.labels.list user, repo
        labels.first.should be_a Hashie::Mash
      end

      it "should get issue information" do
        labels = github.issues.labels.list user, repo
        labels.first.name.should == 'bug'
      end

      it "should yield to a block" do
        github.issues.labels.should_receive(:list).with(user, repo).and_yield('web')
        github.issues.labels.list(user, repo) { |param| 'web' }.should == 'web'
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/labels").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.issues.labels.list user, repo
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # list

  describe "#find" do
    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/labels/#{label_id}").
          to_return(:body => fixture('issues/label.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without label id" do
        expect {
          github.issues.labels.find(user, repo, nil)
        }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.issues.labels.find user, repo, label_id
        a_get("/repos/#{user}/#{repo}/labels/#{label_id}").should have_been_made
      end

      it "should get label information" do
        label = github.issues.labels.find user, repo, label_id
        label.name.should == 'bug'
      end

      it "should return mash" do
        label = github.issues.labels.find user, repo, label_id
        label.should be_a Hashie::Mash
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/labels/#{label_id}").
          to_return(:body => fixture('issues/label.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.issues.labels.find user, repo, label_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # find

  describe "#create" do
    let(:inputs) {
      {
        "name" => "API",
        "color" => "FFFFFF",
      }
    }

    context "resouce created" do
      before do
        stub_post("/repos/#{user}/#{repo}/labels").with(inputs).
          to_return(:body => fixture('issues/label.json'), :status => 201, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to create resource if 'name' input is missing" do
        expect {
          github.issues.labels.create user, repo, inputs.except('name')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should fail to create resource if 'color' input is missing" do
        expect {
          github.issues.labels.create user, repo, inputs.except('color')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should create resource successfully" do
        github.issues.labels.create user, repo, inputs
        a_post("/repos/#{user}/#{repo}/labels").with(inputs).should have_been_made
      end

      it "should return the resource" do
        label = github.issues.labels.create user, repo, inputs
        label.should be_a Hashie::Mash
      end

      it "should get the label information" do
        label = github.issues.labels.create user, repo, inputs
        label.name.should == 'bug'
      end
    end

    context "failed to create resource" do
      before do
        stub_post("/repos/#{user}/#{repo}/labels").with(inputs).
          to_return(:body => fixture('issues/label.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should faile to retrieve resource" do
        expect {
          github.issues.labels.create user, repo, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # create

  describe "#update" do
    let(:inputs) {
      {
        "name" => "API",
        "color" => "FFFFFF",
      }
    }

    context "resouce updated" do
      before do
        stub_patch("/repos/#{user}/#{repo}/labels/#{label_id}").with(inputs).
          to_return(:body => fixture('issues/label.json'), :status => 201, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to create resource if 'name' input is missing" do
        expect {
          github.issues.labels.update user, repo, label_id, inputs.except('name')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should fail to create resource if 'color' input is missing" do
        expect {
          github.issues.labels.update user, repo, label_id, inputs.except('color')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should update resource successfully" do
        github.issues.labels.update user, repo, label_id, inputs
        a_patch("/repos/#{user}/#{repo}/labels/#{label_id}").with(inputs).should have_been_made
      end

      it "should return the resource" do
        label = github.issues.labels.update user, repo, label_id, inputs
        label.should be_a Hashie::Mash
      end

      it "should get the label information" do
        label = github.issues.labels.update user, repo, label_id, inputs
        label.name.should == 'bug'
      end
    end

    context "failed to create resource" do
      before do
        stub_patch("/repos/#{user}/#{repo}/labels/#{label_id}").with(inputs).
          to_return(:body => fixture('issues/label.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should faile to retrieve resource" do
        expect {
          github.issues.labels.update user, repo, label_id, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # update

  describe "#delete" do
    context "resouce removed" do
      before do
        stub_delete("/repos/#{user}/#{repo}/labels/#{label_id}").
          to_return(:body => fixture('issues/label.json'), :status => 201, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should remove resource successfully" do
        github.issues.labels.delete user, repo, label_id
        a_delete("/repos/#{user}/#{repo}/labels/#{label_id}").should have_been_made
      end

      it "should return the resource" do
        label = github.issues.labels.delete user, repo, label_id
        label.should be_a Hashie::Mash
      end

      it "should get the label information" do
        label = github.issues.labels.delete user, repo, label_id
        label.name.should == 'bug'
      end
    end

    context "failed to remove resource" do
      before do
        stub_delete("/repos/#{user}/#{repo}/labels/#{label_id}").
          to_return(:body => fixture('issues/label.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should faile to retrieve resource" do
        expect {
          github.issues.labels.delete user, repo, label_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # delete

  describe '#issue' do
    let(:issue_id) { 1 }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/issues/#{issue_id}/labels").
          to_return(:body => fixture('issues/labels.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without issue_id" do
        expect {
          github.issues.labels.issue user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.issues.labels.issue user, repo, issue_id
        a_get("/repos/#{user}/#{repo}/issues/#{issue_id}/labels").
          should have_been_made
      end

      it "should return array of resources" do
        labels = github.issues.labels.issue user, repo, issue_id
        labels.should be_an Array
        labels.should have(1).items
      end

      it "should be a mash type" do
        labels = github.issues.labels.issue user, repo, issue_id
        labels.first.should be_a Hashie::Mash
      end

      it "should get issue information" do
        labels = github.issues.labels.issue user, repo, issue_id
        labels.first.name.should == 'bug'
      end

      it "should yield to a block" do
        github.issues.labels.should_receive(:issue).
          with(user, repo, issue_id).and_yield('web')
        github.issues.labels.issue(user, repo, issue_id) { |param| 'web' }.should == 'web'
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/issues/#{issue_id}/labels").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.issues.labels.issue user, repo, issue_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # issue

  describe "#add" do
    let(:issue_id) { 1 }
    let(:labels) { "Label 1" }

    context "labels added" do
      before do
        stub_post("/repos/#{user}/#{repo}/issues/#{issue_id}/labels").
          to_return(:body => fixture('issues/labels.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to add labels if issue-id is missing" do
        expect {
          github.issues.labels.add user, repo, nil, labels
        }.to raise_error(ArgumentError)
      end

      it "should create resource successfully" do
        github.issues.labels.add user, repo, issue_id, labels
        a_post("/repos/#{user}/#{repo}/issues/#{issue_id}/labels").should have_been_made
      end

      it "should return the resource" do
        labels = github.issues.labels.add user, repo, issue_id, labels
        labels.first.should be_a Hashie::Mash
      end

      it "should get the label information" do
        labels = github.issues.labels.add user, repo, issue_id, labels
        labels.first.name.should == 'bug'
      end
    end

    context "failed to add labels" do
      before do
        stub_post("/repos/#{user}/#{repo}/issues/#{issue_id}/labels").
          to_return(:body => fixture('issues/label.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should fail to retrieve resource" do
        expect {
          github.issues.labels.add user, repo, issue_id, labels
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # add

  describe "#remove" do
    let(:issue_id) { 1 }
    let(:label_id) { 1 }

    context "remove a label from an issue" do
      before do
        stub_delete("/repos/#{user}/#{repo}/issues/#{issue_id}/labels/#{label_id}").
          to_return(:body => fixture('issues/labels.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should throw exception if issue-id not present" do
        expect {
          github.issues.labels.remove user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should remove label successfully" do
        github.issues.labels.remove user, repo, issue_id, label_id
        a_delete("/repos/#{user}/#{repo}/issues/#{issue_id}/labels/#{label_id}").should have_been_made
      end

      it "should return the resource" do
        labels = github.issues.labels.remove user, repo, issue_id, label_id
        labels.first.should be_a Hashie::Mash
      end

      it "should get the label information" do
        labels = github.issues.labels.remove user, repo, issue_id, label_id
        labels.first.name.should == 'bug'
      end
    end

    context "remove all labels from an issue" do
      before do
        stub_delete("/repos/#{user}/#{repo}/issues/#{issue_id}/labels").
          to_return(:body => "", :status => 204, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should remove labels successfully" do
        github.issues.labels.remove user, repo, issue_id
        a_delete("/repos/#{user}/#{repo}/issues/#{issue_id}/labels").should have_been_made
      end
    end

    context "failed to remove label from an issue" do
      before do
        stub_delete("/repos/#{user}/#{repo}/issues/#{issue_id}/labels/#{label_id}").
          to_return(:body => fixture('issues/label.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should faile to retrieve resource" do
        expect {
          github.issues.labels.remove user, repo, issue_id, label_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # remove

  describe "#replace" do
    let(:issue_id) { 1 }
    let(:labels) { "Label 1" }

    context "labels added" do
      before do
        stub_put("/repos/#{user}/#{repo}/issues/#{issue_id}/labels").
          to_return(:body => fixture('issues/labels.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to add labels if issue-id is missing" do
        expect {
          github.issues.labels.replace user, repo, nil, labels
        }.to raise_error(ArgumentError)
      end

      it "should create resource successfully" do
        github.issues.labels.replace user, repo, issue_id, labels
        a_put("/repos/#{user}/#{repo}/issues/#{issue_id}/labels").should have_been_made
      end

      it "should return the resource" do
        labels = github.issues.labels.replace user, repo, issue_id, labels
        labels.first.should be_a Hashie::Mash
      end

      it "should get the label information" do
        labels = github.issues.labels.replace user, repo, issue_id, labels
        labels.first.name.should == 'bug'
      end
    end

    context "failed to add labels" do
      before do
        stub_put("/repos/#{user}/#{repo}/issues/#{issue_id}/labels").
          to_return(:body => fixture('issues/label.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should fail to retrieve resource" do
        expect {
          github.issues.labels.replace user, repo, issue_id, labels
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # replace

  describe '#milestone' do
    let(:milestone_id) { 1 }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/milestones/#{milestone_id}/labels").
          to_return(:body => fixture('issues/labels.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should throw exception if milestone-id not present" do
        expect {
          github.issues.labels.milestone user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.issues.labels.milestone user, repo, milestone_id
        a_get("/repos/#{user}/#{repo}/milestones/#{milestone_id}/labels").should have_been_made
      end

      it "should return array of resources" do
        labels = github.issues.labels.milestone user, repo, milestone_id
        labels.should be_an Array
        labels.should have(1).items
      end

      it "should be a mash type" do
        labels = github.issues.labels.milestone user, repo, milestone_id
        labels.first.should be_a Hashie::Mash
      end

      it "should get issue information" do
        labels = github.issues.labels.milestone user, repo, milestone_id
        labels.first.name.should == 'bug'
      end

      it "should yield to a block" do
        github.issues.labels.should_receive(:milestone).
          with(user, repo, milestone_id).and_yield('web')
        github.issues.labels.milestone(user, repo, milestone_id) { |param| 'web' }.should == 'web'
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/milestones/#{milestone_id}/labels").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.issues.labels.milestone user, repo, milestone_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # milestone

end # Github::Issues::Labels
