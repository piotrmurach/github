require 'spec_helper'

describe Github::Issues::Labels, :type => :base do

  it { described_class::VALID_LABEL_INPUTS.should_not be_nil }

  describe 'labels' do
    it { github.issues.should respond_to :labels }
    it { github.issues.should respond_to :list_labels }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/labels").
          to_return(:body => fixture('issues/labels.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without username" do
        github.user, github.repo = nil, nil
        expect { github.issues.labels nil, repo }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.issues.labels user, repo
        a_get("/repos/#{user}/#{repo}/labels").should have_been_made
      end

      it "should return array of resources" do
        labels = github.issues.labels user, repo
        labels.should be_an Array
        labels.should have(1).items
      end

      it "should be a mash type" do
        labels = github.issues.labels user, repo
        labels.first.should be_a Hashie::Mash
      end

      it "should get issue information" do
        labels = github.issues.labels user, repo
        labels.first.name.should == 'bug'
      end

      it "should yield to a block" do
        github.issues.should_receive(:labels).with(user, repo).and_yield('web')
        github.issues.labels(user, repo) { |param| 'web' }.should == 'web'
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/labels").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.issues.labels user, repo
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # labels

  describe "label" do
    let(:label_id) { 1 }

    it { github.issues.should respond_to :label }
    it { github.issues.should respond_to :get_label }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/labels/#{label_id}").
          to_return(:body => fixture('issues/label.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without label id" do
        expect { github.issues.label(user, repo, nil)}.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.issues.label user, repo, label_id
        a_get("/repos/#{user}/#{repo}/labels/#{label_id}").should have_been_made
      end

      it "should get label information" do
        label = github.issues.label user, repo, label_id
        label.name.should == 'bug'
      end

      it "should return mash" do
        label = github.issues.label user, repo, label_id
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
          github.issues.label user, repo, label_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # label

  describe "create_label" do
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
          github.issues.create_label user, repo, inputs.except('name')
        }.to raise_error(ArgumentError)
      end

      it "should fail to create resource if 'color' input is missing" do
        expect {
          github.issues.create_label user, repo, inputs.except('color')
        }.to raise_error(ArgumentError)
      end

      it "should create resource successfully" do
        github.issues.create_label user, repo, inputs
        a_post("/repos/#{user}/#{repo}/labels").with(inputs).should have_been_made
      end

      it "should return the resource" do
        label = github.issues.create_label user, repo, inputs
        label.should be_a Hashie::Mash
      end

      it "should get the label information" do
        label = github.issues.create_label user, repo, inputs
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
          github.issues.create_label user, repo, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # create_label

  describe "update_label" do
    let(:label_id) { 1 }
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
          github.issues.update_label user, repo, label_id, inputs.except('name')
        }.to raise_error(ArgumentError)
      end

      it "should fail to create resource if 'color' input is missing" do
        expect {
          github.issues.update_label user, repo, label_id, inputs.except('color')
        }.to raise_error(ArgumentError)
      end

      it "should update resource successfully" do
        github.issues.update_label user, repo, label_id, inputs
        a_patch("/repos/#{user}/#{repo}/labels/#{label_id}").with(inputs).should have_been_made
      end

      it "should return the resource" do
        label = github.issues.update_label user, repo, label_id, inputs
        label.should be_a Hashie::Mash
      end

      it "should get the label information" do
        label = github.issues.update_label user, repo, label_id, inputs
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
          github.issues.update_label user, repo, label_id, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # update_label

  describe "delete_label" do
    let(:label_id) { 1 }

    context "resouce removed" do
      before do
        stub_delete("/repos/#{user}/#{repo}/labels/#{label_id}").
          to_return(:body => fixture('issues/label.json'), :status => 201, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should remove resource successfully" do
        github.issues.delete_label user, repo, label_id
        a_delete("/repos/#{user}/#{repo}/labels/#{label_id}").should have_been_made
      end

      it "should return the resource" do
        label = github.issues.delete_label user, repo, label_id
        label.should be_a Hashie::Mash
      end

      it "should get the label information" do
        label = github.issues.delete_label user, repo, label_id
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
          github.issues.delete_label user, repo, label_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # delete_label

  describe 'labels_for' do
    let(:issue_id) { 1 }

    it { github.issues.should respond_to :labels_for }
    it { github.issues.should respond_to :issue_labels }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/issues/#{issue_id}/labels").
          to_return(:body => fixture('issues/labels.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without issue_id" do
        expect {
          github.issues.labels_for user, repo, nil 
        }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.issues.labels_for user, repo, issue_id
        a_get("/repos/#{user}/#{repo}/issues/#{issue_id}/labels").should have_been_made
      end

      it "should return array of resources" do
        labels = github.issues.labels_for user, repo, issue_id
        labels.should be_an Array
        labels.should have(1).items
      end

      it "should be a mash type" do
        labels = github.issues.labels_for user, repo, issue_id
        labels.first.should be_a Hashie::Mash
      end

      it "should get issue information" do
        labels = github.issues.labels_for user, repo, issue_id
        labels.first.name.should == 'bug'
      end

      it "should yield to a block" do
        github.issues.should_receive(:labels_for).with(user, repo, issue_id).and_yield('web')
        github.issues.labels_for(user, repo, issue_id) { |param| 'web' }.should == 'web'
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/issues/#{issue_id}/labels").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.issues.labels_for user, repo, issue_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # labels_for

  describe "add_labels" do
    let(:issue_id) { 1 }
    let(:labels) { "Label 1" }

    context "labels added" do
      before do
        stub_post("/repos/#{user}/#{repo}/issues/#{issue_id}/labels").
          to_return(:body => fixture('issues/labels.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to add labels if issue-id is missing" do
        expect {
          github.issues.add_labels user, repo, nil, labels
        }.to raise_error(ArgumentError)
      end

      it "should create resource successfully" do
        github.issues.add_labels user, repo, issue_id, labels
        a_post("/repos/#{user}/#{repo}/issues/#{issue_id}/labels").should have_been_made
      end

      it "should return the resource" do
        labels = github.issues.add_labels user, repo, issue_id, labels
        labels.first.should be_a Hashie::Mash
      end

      it "should get the label information" do
        labels = github.issues.add_labels user, repo, issue_id, labels
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
          github.issues.add_labels user, repo, issue_id, labels
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # add_labels

  describe "remove_label" do
    let(:issue_id) { 1 }
    let(:label_id) { 1 }

    context "remove a label from an issue" do
      before do
        stub_delete("/repos/#{user}/#{repo}/issues/#{issue_id}/labels/#{label_id}").
          to_return(:body => fixture('issues/labels.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should throw exception if issue-id not present" do
        expect {
          github.issues.remove_label user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should remove label successfully" do
        github.issues.remove_label user, repo, issue_id, label_id
        a_delete("/repos/#{user}/#{repo}/issues/#{issue_id}/labels/#{label_id}").should have_been_made
      end

      it "should return the resource" do
        labels = github.issues.remove_label user, repo, issue_id, label_id
        labels.first.should be_a Hashie::Mash
      end

      it "should get the label information" do
        labels = github.issues.remove_label user, repo, issue_id, label_id
        labels.first.name.should == 'bug'
      end
    end

    context "remove all labels from an issue" do
      before do
        stub_delete("/repos/#{user}/#{repo}/issues/#{issue_id}/labels").
          to_return(:body => "", :status => 204, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should remove labels successfully" do
        github.issues.remove_label user, repo, issue_id
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
          github.issues.remove_label user, repo, issue_id, label_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # remove_label

  describe "replace_labels" do
    let(:issue_id) { 1 }
    let(:labels) { "Label 1" }

    context "labels added" do
      before do
        stub_put("/repos/#{user}/#{repo}/issues/#{issue_id}/labels").
          to_return(:body => fixture('issues/labels.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to add labels if issue-id is missing" do
        expect {
          github.issues.replace_labels user, repo, nil, labels
        }.to raise_error(ArgumentError)
      end

      it "should create resource successfully" do
        github.issues.replace_labels user, repo, issue_id, labels
        a_put("/repos/#{user}/#{repo}/issues/#{issue_id}/labels").should have_been_made
      end

      it "should return the resource" do
        labels = github.issues.replace_labels user, repo, issue_id, labels
        labels.first.should be_a Hashie::Mash
      end

      it "should get the label information" do
        labels = github.issues.replace_labels user, repo, issue_id, labels
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
          github.issues.replace_labels user, repo, issue_id, labels
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # add_labels

  describe 'milestone_labels' do
    let(:milestone_id) { 1 }

    it { github.issues.should respond_to :milestone_labels }
    it { github.issues.should respond_to :milestone_issues_labels }
    it { github.issues.should respond_to :list_milestone_labels }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/milestones/#{milestone_id}/labels").
          to_return(:body => fixture('issues/labels.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should throw exception if milestone-id not present" do
        expect {
          github.issues.remove_label user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.issues.milestone_labels user, repo, milestone_id
        a_get("/repos/#{user}/#{repo}/milestones/#{milestone_id}/labels").should have_been_made
      end

      it "should return array of resources" do
        labels = github.issues.milestone_labels user, repo, milestone_id
        labels.should be_an Array
        labels.should have(1).items
      end

      it "should be a mash type" do
        labels = github.issues.milestone_labels user, repo, milestone_id
        labels.first.should be_a Hashie::Mash
      end

      it "should get issue information" do
        labels = github.issues.milestone_labels user, repo, milestone_id
        labels.first.name.should == 'bug'
      end

      it "should yield to a block" do
        github.issues.should_receive(:milestone_labels).with(user, repo, milestone_id).and_yield('web')
        github.issues.milestone_labels(user, repo, milestone_id) { |param| 'web' }.should == 'web'
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/milestones/#{milestone_id}/labels").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.issues.milestone_labels user, repo, milestone_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # milestone_labels

end # Github::Issues::Labels
