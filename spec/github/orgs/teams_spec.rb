require 'spec_helper'

describe Github::Orgs::Teams do
  let(:github) { Github.new }
  let(:user) { 'peter-murach' }
  let(:org) { 'github' }
  let(:repo) { 'github' }
  let(:team)   { 'github' }
  let(:member) { 'github' }

  after { reset_authentication_for github }

  describe "#list" do
    context "resource found" do
      before do
        stub_get("/orgs/#{org}/teams").
          to_return(:body => fixture('orgs/teams.json'), :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without org name" do
        expect { github.orgs.teams.list nil }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.orgs.teams.list org
        a_get("/orgs/#{org}/teams").should have_been_made
      end

      it "should return array of resources" do
        teams = github.orgs.teams.list org
        teams.should be_an Array
        teams.should have(1).items
      end

      it "should be a mash type" do
        teams = github.orgs.teams.list org
        teams.first.should be_a Hashie::Mash
      end

      it "should get teams information" do
        teams = github.orgs.teams.list org
        teams.first.name.should == 'Owners'
      end

      it "should yield to a block" do
        github.orgs.teams.should_receive(:list).with(org).and_yield('web')
        github.orgs.teams.list(org) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/orgs/#{org}/teams").
          to_return(:body => '', :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.orgs.teams.list org
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # list

  describe "#get" do
    context "resource found" do
      before do
        stub_get("/teams/#{team}").
          to_return(:body => fixture('orgs/team.json'), :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without org name" do
        expect { github.orgs.teams.get nil }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.orgs.teams.get team
        a_get("/teams/#{team}").should have_been_made
      end

      it "should get team information" do
        team_res = github.orgs.teams.get team
        team_res.id.should == 1
        team_res.name.should == 'Owners'
      end

      it "should return mash" do
        team_res = github.orgs.teams.get team
        team_res.should be_a Hashie::Mash
      end
    end

    context "resource not found" do
      before do
        stub_get("/teams/#{team}").
          to_return(:body => fixture('orgs/team.json'), :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.orgs.teams.get team
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # get

  describe "#create" do
    let(:inputs) { { :name => 'new team', :permissions => 'push', :repo_names => [ 'github/dotfiles' ] }}

    context "resouce created" do
      before do
        stub_post("/orgs/#{org}/teams").with(inputs).
          to_return(:body => fixture('orgs/team.json'), :status => 201, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to create resource if 'org_name' param is missing" do
        expect { github.orgs.teams.create nil, inputs }.to raise_error(ArgumentError)
      end

      it "should failt to create resource if 'name' input is missing" do
        expect {
          github.orgs.teams.create org, inputs.except(:name)
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should create resource successfully" do
        github.orgs.teams.create org, inputs
        a_post("/orgs/#{org}/teams").with(inputs).should have_been_made
      end

      it "should return the resource" do
        team = github.orgs.teams.create org, inputs
        team.should be_a Hashie::Mash
      end

      it "should get the team information" do
        team = github.orgs.teams.create org, inputs
        team.name.should == 'Owners'
      end
    end

    context "failed to create resource" do
      before do
        stub_post("/orgs/#{org}/teams").with(inputs).
          to_return(:body => '', :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should faile to retrieve resource" do
        expect {
          github.orgs.teams.create org, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # create

  describe "#edit" do
    let(:inputs) { { :name => 'new team', :permissions => 'push' } }

    context "resouce edited" do
      before do
        stub_patch("/teams/#{team}").with(inputs).
          to_return(:body => fixture('orgs/team.json'), :status => 201,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to create resource if 'team name' param is missing" do
        expect { github.orgs.teams.edit nil, inputs }.to raise_error(ArgumentError)
      end

      it "should failt to create resource if 'name' input is missing" do
        expect {
          github.orgs.teams.edit team, inputs.except(:name)
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should create resource successfully" do
        github.orgs.teams.edit team, inputs
        a_patch("/teams/#{team}").with(inputs).should have_been_made
      end

      it "should return the resource" do
        edited_team = github.orgs.teams.edit team, inputs
        edited_team.should be_a Hashie::Mash
      end

      it "should get the team information" do
        edited_team = github.orgs.teams.edit team, inputs
        edited_team.name.should == 'Owners'
      end
    end

    context "failed to create resource" do
      before do
        stub_patch("/teams/#{team}").with(inputs).
          to_return(:body => fixture('orgs/team.json'), :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should faile to retrieve resource" do
        expect {
          github.orgs.teams.edit team, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # edit

  describe "#delete" do
    let(:team_id) { 1 }

    it { github.orgs.teams.should respond_to :remove }

    context "resource edited successfully" do
      before do
        stub_delete("/teams/#{team}").
          to_return(:body => '', :status => 204, :headers => { :content_type => "application/json; charset=utf-8"})
      end

      it "should fail to delete without 'team_id' parameter" do
        expect { github.orgs.teams.delete nil }.to raise_error(ArgumentError)
      end

      it "should delete the resource" do
        github.orgs.teams.delete team
        a_delete("/teams/#{team}").should have_been_made
      end
    end

    context "failed to edit resource" do
      before do
        stub_delete("/teams/#{team}").
          to_return(:body => '', :status => 404, :headers => { :content_type => "application/json; charset=utf-8"})
      end

      it "should fail to find resource" do
        expect {
          github.orgs.teams.delete team
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # delete

  describe "#list_members" do
    context "resource found" do
      before do
        stub_get("/teams/#{team}/members").
          to_return(:body => fixture('orgs/teams.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without org name" do
        expect { github.orgs.teams.list_members }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.orgs.teams.list_members team
        a_get("/teams/#{team}/members").should have_been_made
      end

      it "should return array of resources" do
        teams = github.orgs.teams.list_members team
        teams.should be_an Array
        teams.should have(1).items
      end

      it "should be a mash type" do
        teams = github.orgs.teams.list_members team
        teams.first.should be_a Hashie::Mash
      end

      it "should get team members information" do
        teams = github.orgs.teams.list_members team
        teams.first.name.should == 'Owners'
      end

      it "should yield to a block" do
        github.orgs.teams.should_receive(:list_members).with(team).and_yield('web')
        github.orgs.teams.list_members(team) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/teams/#{team}/members").
          to_return(:body => '', :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.orgs.teams.list_members team
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # list_members

  describe "team_member?" do
    context "with teamname ane membername passed" do

      context "this repo is being watched by the user"
        before do
          stub_get("/teams/#{team}/members/#{member}").
            to_return(:body => "", :status => 404, :headers => {:user_agent => github.user_agent})
        end

      it "should return false if resource not found" do
        team_membership = github.orgs.teams.team_member? team, member
        team_membership.should be_false
      end

      it "should return true if resoure found" do
        stub_get("/teams/#{team}/members/#{member}").
          to_return(:body => "", :status => 204, :headers => {:user_agent => github.user_agent})
        team_membership = github.orgs.teams.team_member? team, member
        team_membership.should be_true
      end

    end

    context "without org name and member name passed" do
      it "should fail validation " do
        expect {
          github.orgs.teams.team_member?(nil, nil)
        }.to raise_error(ArgumentError)
      end
    end
  end # team_member?

  describe "#add_member" do
    context "resouce added" do
      before do
        stub_put("/teams/#{team}/members/#{member}").
          to_return(:body => '', :status => 204, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to add resource if 'team' input is nil" do
        expect {
          github.orgs.teams.add_member nil, member
        }.to raise_error(ArgumentError)
      end

      it "should fail to add resource if 'member' input is nil" do
        expect {
          github.orgs.teams.add_member team, nil
        }.to raise_error(ArgumentError)
      end

      it "should add resource successfully" do
        github.orgs.teams.add_member team, member
        a_put("/teams/#{team}/members/#{member}").should have_been_made
      end
    end

    context "failed to add resource" do
      before do
        stub_put("/teams/#{team}/members/#{member}").
          to_return(:body => '', :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to add resource" do
        expect {
          github.orgs.teams.add_member team, member
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # add_member

  describe "#remove_member" do
    context "resouce deleted" do
      before do
        stub_delete("/teams/#{team}/members/#{member}").
          to_return(:body => '', :status => 204, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to delete resource if 'team' input is nil" do
        expect {
          github.orgs.teams.remove_member nil, member
        }.to raise_error(ArgumentError)
      end

      it "should fail to delete resource if 'member' input is nil" do
        expect {
          github.orgs.teams.remove_member member, nil
        }.to raise_error(ArgumentError)
      end

      it "should add resource successfully" do
        github.orgs.teams.remove_member team, member
        a_delete("/teams/#{team}/members/#{member}").should have_been_made
      end
    end

    context "failed to remove resource" do
      before do
        stub_delete("/teams/#{team}/members/#{member}").
          to_return(:body => '', :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to remove resource" do
        expect {
          github.orgs.teams.remove_member team, member
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # remove_member

  describe "#list_repos" do
    context "resource found" do
      before do
        stub_get("/teams/#{team}/repos").
          to_return(:body => fixture('orgs/team_repos.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without team name" do
        expect { github.orgs.teams.list_repos nil }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.orgs.teams.list_repos team
        a_get("/teams/#{team}/repos").should have_been_made
      end

      it "should return array of resources" do
        team_repos = github.orgs.teams.list_repos team
        team_repos.should be_an Array
        team_repos.should have(1).items
      end

      it "should be a mash type" do
        team_repos = github.orgs.teams.list_repos team
        team_repos.first.should be_a Hashie::Mash
      end

      it "should get teams information" do
        team_repos = github.orgs.teams.list_repos team
        team_repos.first.name.should == 'github'
      end

      it "should yield to a block" do
        github.orgs.teams.should_receive(:list_repos).with(team).and_yield('web')
        github.orgs.teams.list_repos(team) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/teams/#{team}/repos").
          to_return(:body => '', :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.orgs.teams.list_repos team
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # list_repos

  describe "team_repo?" do
    context "with teamname, username ane reponame passed" do

      context "this repo is managed by the team"
        before do
          stub_get("/teams/#{team}/repos/#{user}/#{repo}").
            to_return(:body => "", :status => 404, :headers => {:user_agent => github.user_agent})
        end

      it "should return false if resource not found" do
        team_managed = github.orgs.teams.team_repo? team, user, repo
        team_managed.should be_false
      end

      it "should return true if resoure found" do
        stub_get("/teams/#{team}/repos/#{user}/#{repo}").
          to_return(:body => "", :status => 204, :headers => {:user_agent => github.user_agent})
        team_managed = github.orgs.teams.team_repo? team, user, repo
        team_managed.should be_true
      end
    end

    context "without org name and member name passed" do
      it "should fail validation " do
        expect {
          github.orgs.teams.team_repo?(nil, nil, nil)
        }.to raise_error(ArgumentError)
      end
    end
  end # team_repo?

  describe "#add_repo" do
    context "resouce added" do
      before do
        stub_put("/teams/#{team}/repos/#{user}/#{repo}").
          to_return(:body => '', :status => 204, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to add resource if 'team' input is nil" do
        expect {
          github.orgs.teams.add_repo nil, user, repo
        }.to raise_error(ArgumentError)
      end

      it "should fail to add resource if 'user' input is nil" do
        expect {
          github.orgs.teams.add_repo team, nil, repo
        }.to raise_error(ArgumentError)
      end

      it "should add resource successfully" do
        github.orgs.teams.add_repo team, user, repo
        a_put("/teams/#{team}/repos/#{user}/#{repo}").should have_been_made
      end
    end

    context "failed to add resource" do
      before do
        stub_put("/teams/#{team}/repos/#{user}/#{repo}").
          to_return(:body => '', :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to add resource" do
        expect {
          github.orgs.teams.add_repo team, user, repo
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # add_repo

  describe "#remove_repo" do
    context "resouce deleted" do
      before do
        stub_delete("/teams/#{team}/repos/#{user}/#{repo}").
          to_return(:body => '', :status => 204, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to delete resource if 'team' input is nil" do
        expect {
          github.orgs.teams.remove_repo nil, user, repo
        }.to raise_error(ArgumentError)
      end

      it "should fail to delete resource if 'user' input is nil" do
        expect {
          github.orgs.teams.remove_repo team, nil, repo
        }.to raise_error(ArgumentError)
      end

      it "should add resource successfully" do
        github.orgs.teams.remove_repo team, user, repo
        a_delete("/teams/#{team}/repos/#{user}/#{repo}").should have_been_made
      end
    end

    context "failed to remove resource" do
      before do
        stub_delete("/teams/#{team}/repos/#{user}/#{repo}").
          to_return(:body => '', :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to remove resource" do
        expect {
          github.orgs.teams.remove_repo team, user, repo
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # remove_repo

end # Github::Orgs::Teams
