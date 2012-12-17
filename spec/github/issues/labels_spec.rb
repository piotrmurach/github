require 'spec_helper'

describe Github::Issues::Labels do
  let(:github) { Github.new }
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:label_id) { 1 }

  after { github.user, github.repo, github.oauth_token = nil, nil, nil }

  it { described_class::VALID_LABEL_INPUTS.should_not be_nil }

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

end # Github::Issues::Labels
