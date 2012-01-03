require 'spec_helper'

describe Github::Issues::Milestones, :type => :base do

  it { described_class::VALID_MILESTONE_OPTIONS.should_not be_nil }
  it { described_class::VALID_MILESTONE_INPUTS.should_not be_nil }

  describe 'milestones' do
    it { github.issues.should respond_to :milestones }
    it { github.issues.should respond_to :list_milestones }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/milestones").
          to_return(:body => fixture('issues/milestones.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without username" do
        github.user, github.repo = nil, nil
        expect { github.issues.milestones nil, repo }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.issues.milestones user, repo
        a_get("/repos/#{user}/#{repo}/milestones").should have_been_made
      end

      it "should return array of resources" do
        milestones = github.issues.milestones user, repo
        milestones.should be_an Array
        milestones.should have(1).items
      end

      it "should be a mash type" do
        milestones = github.issues.milestones user, repo
        milestones.first.should be_a Hashie::Mash
      end

      it "should get issue information" do
        milestones = github.issues.milestones user, repo
        milestones.first.title.should == 'v1.0'
      end

      it "should yield to a block" do
        github.issues.should_receive(:milestones).with(user, repo).and_yield('web')
        github.issues.milestones(user, repo) { |param| 'web' }.should == 'web'
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/milestones").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.issues.milestones user, repo
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # milestones

  describe "milestone" do
    let(:milestone_id) { 1 }

    it { github.issues.should respond_to :milestone }
    it { github.issues.should respond_to :get_milestone }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/milestones/#{milestone_id}").
          to_return(:body => fixture('issues/milestone.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without milestone id" do
        expect { github.issues.milestone(user, repo, nil)}.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.issues.milestone user, repo, milestone_id
        a_get("/repos/#{user}/#{repo}/milestones/#{milestone_id}").should have_been_made
      end

      it "should get milestone information" do
        milestone = github.issues.milestone user, repo, milestone_id
        milestone.number.should == milestone_id
        milestone.title.should == 'v1.0'
      end

      it "should return mash" do
        milestone = github.issues.milestone user, repo, milestone_id
        milestone.should be_a Hashie::Mash
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/milestones/#{milestone_id}").
          to_return(:body => fixture('issues/milestone.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.issues.milestone user, repo, milestone_id
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # milestone

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
          to_return(:body => fixture('issues/milestone.json'), :status => 201, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to create resource if 'title' input is missing" do
        expect {
          github.issues.create_milestone user, repo, inputs.except('title')
        }.to raise_error(ArgumentError)
      end

      it "should create resource successfully" do
        github.issues.create_milestone user, repo, inputs
        a_post("/repos/#{user}/#{repo}/milestones").with(inputs).should have_been_made
      end

      it "should return the resource" do
        milestone = github.issues.create_milestone user, repo, inputs
        milestone.should be_a Hashie::Mash
      end

      it "should get the milestone information" do
        milestone = github.issues.create_milestone user, repo, inputs
        milestone.title.should == 'v1.0'
      end
    end

    context "failed to create resource" do
      before do
        stub_post("/repos/#{user}/#{repo}/milestones").with(inputs).
          to_return(:body => fixture('issues/milestone.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should faile to retrieve resource" do
        expect {
          github.issues.create_milestone user, repo, inputs
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # create_milestone

  describe "update_milestone" do
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
        stub_patch("/repos/#{user}/#{repo}/milestones/#{milestone_id}").with(inputs).
          to_return(:body => fixture('issues/milestone.json'), :status => 201, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to create resource if 'title' input is missing" do
        expect {
          github.issues.update_milestone user, repo, milestone_id, inputs.except('title')
        }.to raise_error(ArgumentError)
      end

      it "should update resource successfully" do
        github.issues.update_milestone user, repo, milestone_id, inputs
        a_patch("/repos/#{user}/#{repo}/milestones/#{milestone_id}").with(inputs).should have_been_made
      end

      it "should return the resource" do
        milestone = github.issues.update_milestone user, repo, milestone_id, inputs
        milestone.should be_a Hashie::Mash
      end

      it "should get the milestone information" do
        milestone = github.issues.update_milestone user, repo, milestone_id, inputs
        milestone.title.should == 'v1.0'
      end
    end

    context "failed to create resource" do
      before do
        stub_patch("/repos/#{user}/#{repo}/milestones/#{milestone_id}").with(inputs).
          to_return(:body => fixture('issues/milestone.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should faile to retrieve resource" do
        expect {
          github.issues.update_milestone user, repo, milestone_id, inputs
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # update_milestone

  describe "delete_milestone" do
    let(:milestone_id) { 1 }

    context "resouce removed" do
      before do
        stub_delete("/repos/#{user}/#{repo}/milestones/#{milestone_id}").
          to_return(:body => fixture('issues/milestone.json'), :status => 201, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should remove resource successfully" do
        github.issues.delete_milestone user, repo, milestone_id
        a_delete("/repos/#{user}/#{repo}/milestones/#{milestone_id}").should have_been_made
      end

      it "should return the resource" do
        milestone = github.issues.delete_milestone user, repo, milestone_id
        milestone.should be_a Hashie::Mash
      end

      it "should get the milestone information" do
        milestone = github.issues.delete_milestone user, repo, milestone_id
        milestone.title.should == 'v1.0'
      end
    end

    context "failed to remove resource" do
      before do
        stub_delete("/repos/#{user}/#{repo}/milestones/#{milestone_id}").
          to_return(:body => fixture('issues/milestone.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should faile to retrieve resource" do
        expect {
          github.issues.delete_milestone user, repo, milestone_id
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # delete_milestone

end # Github::Issues::Milestones
