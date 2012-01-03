require 'spec_helper'

describe Github::Orgs::Teams, :type => :base do

  let(:team)   { 'github' }
  let(:member) { 'github' }

  describe "teams" do
    context "resource found" do
      before do
        stub_get("/orgs/#{org}/teams").
          to_return(:body => fixture('orgs/teams.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without org name" do
        expect { github.orgs.teams nil }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.orgs.teams org
        a_get("/orgs/#{org}/teams").should have_been_made
      end

      it "should return array of resources" do
        teams = github.orgs.teams org
        teams.should be_an Array
        teams.should have(1).items
      end

      it "should be a mash type" do
        teams = github.orgs.teams org
        teams.first.should be_a Hashie::Mash
      end

      it "should get teams information" do
        teams = github.orgs.teams org
        teams.first.name.should == 'Owners'
      end

      it "should yield to a block" do
        github.orgs.should_receive(:teams).with(org).and_yield('web')
        github.orgs.teams(org) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/orgs/#{org}/teams").
          to_return(:body => fixture('orgs/teams.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.orgs.teams org
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # teams

  describe "team" do
    context "resource found" do
      before do
        stub_get("/teams/#{team}").
          to_return(:body => fixture('orgs/team.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without org name" do
        expect { github.orgs.team nil }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.orgs.team team
        a_get("/teams/#{team}").should have_been_made
      end

      it "should get team information" do
        team_res = github.orgs.team team
        team_res.id.should == 1
        team_res.name.should == 'Owners'
      end

      it "should return mash" do
        team_res = github.orgs.team team
        team_res.should be_a Hashie::Mash
      end
    end

    context "resource not found" do
      before do
        stub_get("/teams/#{team}").
          to_return(:body => fixture('orgs/team.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.orgs.team team
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # team

  describe "create_team" do
    let(:inputs) { { :name => 'new team', :permissions => 'push', :repo_names => [ 'github/dotfiles' ] }}

    context "resouce created" do
      before do
        stub_post("/orgs/#{org}/teams").with(inputs).
          to_return(:body => fixture('orgs/team.json'), :status => 201, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should fail to create resource if 'org_name' param is missing" do
        expect { github.orgs.create_team nil, inputs }.to raise_error(ArgumentError)
      end

      it "should failt to create resource if 'name' input is missing" do
        expect {
          github.orgs.create_team org, inputs.except(:name)
        }.to raise_error(ArgumentError)
      end

      it "should create resource successfully" do
        github.orgs.create_team org, inputs
        a_post("/orgs/#{org}/teams").with(inputs).should have_been_made
      end

      it "should return the resource" do
        team = github.orgs.create_team org, inputs
        team.should be_a Hashie::Mash
      end

      it "should get the team information" do
        team = github.orgs.create_team org, inputs
        team.name.should == 'Owners'
      end
    end

    context "failed to create resource" do
      before do
        stub_post("/orgs/#{org}/teams").with(inputs).
          to_return(:body => fixture('orgs/team.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should faile to retrieve resource" do
        expect {
          github.orgs.create_team org, inputs
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # create_team

  describe "edit_team" do
    let(:inputs) { { :name => 'new team', :permissions => 'push' } }

    context "resouce edited" do
      before do
        stub_patch("/teams/#{team}").with(inputs).
          to_return(:body => fixture('orgs/team.json'), :status => 201, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should fail to create resource if 'team name' param is missing" do
        expect { github.orgs.edit_team nil, inputs }.to raise_error(ArgumentError)
      end

      it "should failt to create resource if 'name' input is missing" do
        expect {
          github.orgs.edit_team team, inputs.except(:name)
        }.to raise_error(ArgumentError)
      end

      it "should create resource successfully" do
        github.orgs.edit_team team, inputs
        a_patch("/teams/#{team}").with(inputs).should have_been_made
      end

      it "should return the resource" do
        edited_team = github.orgs.edit_team team, inputs
        edited_team.should be_a Hashie::Mash
      end

      it "should get the team information" do
        edited_team = github.orgs.edit_team team, inputs
        edited_team.name.should == 'Owners'
      end
    end

    context "failed to create resource" do
      before do
        stub_patch("/teams/#{team}").with(inputs).
          to_return(:body => fixture('orgs/team.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should faile to retrieve resource" do
        expect {
          github.orgs.edit_team team, inputs
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # edit_team

  describe "delete_team" do
    let(:team_id) { 1 }

    context "resource edited successfully" do
      before do
        stub_delete("/teams/#{team}").
          to_return(:body => '', :status => 204, :headers => { :content_type => "application/json; charset=utf-8"})
      end

      it "should fail to delete without 'team_id' parameter" do
        github.user, github.repo = nil, nil
        expect { github.orgs.delete_team }.to raise_error(ArgumentError)
      end

      it "should delete the resource" do
        github.orgs.delete_team team
        a_delete("/teams/#{team}").should have_been_made
      end
    end

    context "failed to edit resource" do
      before do
        stub_delete("/teams/#{team}").
          to_return(:body => '', :status => 404, :headers => { :content_type => "application/json; charset=utf-8"})
      end

      it "should fail to find resource" do
        expect { github.orgs.delete_team team }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # delete_team

  describe "team_members" do
    context "resource found" do
      before do
        stub_get("/teams/#{team}/members").
          to_return(:body => fixture('orgs/teams.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without org name" do
        expect { github.orgs.team_members }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.orgs.team_members team
        a_get("/teams/#{team}/members").should have_been_made
      end

      it "should return array of resources" do
        teams = github.orgs.team_members team
        teams.should be_an Array
        teams.should have(1).items
      end

      it "should be a mash type" do
        teams = github.orgs.team_members team
        teams.first.should be_a Hashie::Mash
      end

      it "should get team members information" do
        teams = github.orgs.team_members team
        teams.first.name.should == 'Owners'
      end

      it "should yield to a block" do
        github.orgs.should_receive(:team_members).with(team).and_yield('web')
        github.orgs.team_members(team) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/teams/#{team}/members").
          to_return(:body => fixture('orgs/teams.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.orgs.team_members team
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # team_members

  describe "team_member?" do
    context "with teamname ane membername passed" do

      context "this repo is being watched by the user"
        before do
          github.oauth_token = nil
          github.user = nil
          stub_get("/teams/#{team}/members/#{member}").
            to_return(:body => "", :status => 404, :headers => {:user_agent => github.user_agent})
        end

      it "should return false if resource not found" do
        team_membership = github.orgs.team_member? team, member
        team_membership.should be_false
      end

      it "should return true if resoure found" do
        stub_get("/teams/#{team}/members/#{member}").
          to_return(:body => "", :status => 204, :headers => {:user_agent => github.user_agent})
        team_membership = github.orgs.team_member? team, member
        team_membership.should be_true
      end

    end

    context "without org name and member name passed" do
      it "should fail validation " do
        expect { github.orgs.team_member?(nil, nil) }.to raise_error(ArgumentError)
      end
    end
  end # member?

  describe "add_team_member" do
    context "resouce added" do
      before do
        stub_put("/teams/#{team}/members/#{member}").
          to_return(:body => '', :status => 204, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to add resource if 'team' input is nil" do
        expect {
          github.orgs.add_team_member nil, member
        }.to raise_error(ArgumentError)
      end

      it "should fail to add resource if 'member' input is nil" do
        expect {
          github.orgs.add_team_member team, nil
        }.to raise_error(ArgumentError)
      end

      it "should add resource successfully" do
        github.orgs.add_team_member team, member
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
          github.orgs.add_team_member team, member
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # add_team_member

  describe "remove_team_member" do
    context "resouce deleted" do
      before do
        stub_delete("/teams/#{team}/members/#{member}").
          to_return(:body => '', :status => 204, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to delete resource if 'team' input is nil" do
        expect {
          github.orgs.remove_team_member nil, member
        }.to raise_error(ArgumentError)
      end

      it "should fail to delete resource if 'member' input is nil" do
        expect {
          github.orgs.remove_team_member member, nil
        }.to raise_error(ArgumentError)
      end

      it "should add resource successfully" do
        github.orgs.remove_team_member team, member
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
          github.orgs.remove_team_member team, member
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # remove_team_member

  describe "team_repos" do
    context "resource found" do
      before do
        stub_get("/teams/#{team}/repos").
          to_return(:body => fixture('orgs/team_repos.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without team name" do
        expect { github.orgs.team_repos nil }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.orgs.team_repos team
        a_get("/teams/#{team}/repos").should have_been_made
      end

      it "should return array of resources" do
        team_repos = github.orgs.team_repos team
        team_repos.should be_an Array
        team_repos.should have(1).items
      end

      it "should be a mash type" do
        team_repos = github.orgs.team_repos team
        team_repos.first.should be_a Hashie::Mash
      end

      it "should get teams information" do
        team_repos = github.orgs.team_repos team
        team_repos.first.name.should == 'github'
      end

      it "should yield to a block" do
        github.orgs.should_receive(:team_repos).with(team).and_yield('web')
        github.orgs.team_repos(team) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/teams/#{team}/repos").
          to_return(:body => '', :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.orgs.team_repos team
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # team_repos

  describe "team_repo?" do
    context "with teamname, username ane reponame passed" do

      context "this repo is managed by the team"
        before do
          github.oauth_token = nil
          github.user = nil
          stub_get("/teams/#{team}/repos/#{user}/#{repo}").
            to_return(:body => "", :status => 404, :headers => {:user_agent => github.user_agent})
        end

      it "should return false if resource not found" do
        team_managed = github.orgs.team_repo? team, user, repo
        team_managed.should be_false
      end

      it "should return true if resoure found" do
        stub_get("/teams/#{team}/repos/#{user}/#{repo}").
          to_return(:body => "", :status => 204, :headers => {:user_agent => github.user_agent})
        team_managed = github.orgs.team_repo? team, user, repo
        team_managed.should be_true
      end
    end

    context "without org name and member name passed" do
      it "should fail validation " do
        expect { github.orgs.team_repo?(nil, nil, nil) }.to raise_error(ArgumentError)
      end
    end
  end # team_repo?

  describe "add_team_repo" do
    context "resouce added" do
      before do
        stub_put("/teams/#{team}/repos/#{user}/#{repo}").
          to_return(:body => '', :status => 204, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to add resource if 'team' input is nil" do
        expect {
          github.orgs.add_team_member nil, user, repo
        }.to raise_error(ArgumentError)
      end

      it "should fail to add resource if 'user' input is nil" do
        expect {
          github.orgs.add_team_member team, nil, repo
        }.to raise_error(ArgumentError)
      end

      it "should add resource successfully" do
        github.orgs.add_team_repo team, user, repo
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
          github.orgs.add_team_repo team, user, repo
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # add_team_repo

  describe "remove_team_member" do
    context "resouce deleted" do
      before do
        stub_delete("/teams/#{team}/repos/#{user}/#{repo}").
          to_return(:body => '', :status => 204, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to delete resource if 'team' input is nil" do
        expect {
          github.orgs.remove_team_repo nil, user, repo
        }.to raise_error(ArgumentError)
      end

      it "should fail to delete resource if 'user' input is nil" do
        expect {
          github.orgs.remove_team_repo team, nil, repo
        }.to raise_error(ArgumentError)
      end

      it "should add resource successfully" do
        github.orgs.remove_team_repo team, user, repo
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
          github.orgs.remove_team_repo team, user, repo
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # remove_team_repo

end # Github::Orgs::Teams
