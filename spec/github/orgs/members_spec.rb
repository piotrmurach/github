require 'spec_helper'

describe Github::Orgs::Members do
  let(:github) { Github.new }
  let(:member) { 'peter-murach' }
  let(:org)    { 'github' }

  after { github.user, github.repo, github.oauth_token = nil, nil, nil }

  describe "members" do
    context "resource found" do
      before do
        stub_get("/orgs/#{org}/members").
          to_return(:body => fixture('orgs/members.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without org name" do
        expect { github.orgs.members }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.orgs.members org
        a_get("/orgs/#{org}/members").should have_been_made
      end

      it "should return array of resources" do
        members = github.orgs.members org
        members.should be_an Array
        members.should have(1).items
      end

      it "should be a mash type" do
        members = github.orgs.members org
        members.first.should be_a Hashie::Mash
      end

      it "should get members information" do
        members = github.orgs.members org
        members.first.login.should == 'octocat'
      end

      it "should yield to a block" do
        github.orgs.should_receive(:members).with(org).and_yield('web')
        github.orgs.members(org) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/orgs/#{org}/members").
          to_return(:body => fixture('orgs/members.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.orgs.members org
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # members

  describe "member?" do
    context "with username ane reponame passed" do
      context "this repo is being watched by the user"
        before do
          stub_get("/orgs/#{org}/members/#{member}").
            to_return(:body => "", :status => 404, :headers => {:user_agent => github.user_agent})
        end

      it "should return false if resource not found" do
        membership = github.orgs.member? org, member
        membership.should be_false
      end

      it "should return true if resoure found" do
          stub_get("/orgs/#{org}/members/#{member}").
            to_return(:body => "", :status => 204, :headers => {:user_agent => github.user_agent})
        membership = github.orgs.member? org, member
        membership.should be_true
      end
    end

    context "without org name and member name passed" do
      it "should fail validation " do
        expect { github.orgs.member?(nil, nil) }.to raise_error(ArgumentError)
      end
    end
  end # member?

  describe "public_members" do
    context "resource found" do
      before do
        stub_get("/orgs/#{org}/public_members").
          to_return(:body => fixture('orgs/members.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without org name" do
        expect { github.orgs.public_members }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.orgs.public_members org
        a_get("/orgs/#{org}/public_members").should have_been_made
      end

      it "should return array of resources" do
        public_members = github.orgs.public_members org
        public_members.should be_an Array
        public_members.should have(1).items
      end

      it "should be a mash type" do
        public_members = github.orgs.public_members org
        public_members.first.should be_a Hashie::Mash
      end

      it "should get public_members information" do
        public_members = github.orgs.public_members org
        public_members.first.login.should == 'octocat'
      end

      it "should yield to a block" do
        github.orgs.should_receive(:public_members).with(org).and_yield('web')
        github.orgs.public_members(org) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/orgs/#{org}/public_members").
          to_return(:body => fixture('orgs/members.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.orgs.public_members org
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # public_members

  describe "public_member?" do
    context "with username ane reponame passed" do
      context "this repo is being watched by the user"
        before do
          stub_get("/orgs/#{org}/public_members/#{member}").
            to_return(:body => "", :status => 404, :headers => {:user_agent => github.user_agent})
        end

      it "should return false if resource not found" do
        public_member = github.orgs.public_member? org, member
        public_member.should be_false
      end

      it "should return true if resoure found" do
          stub_get("/orgs/#{org}/public_members/#{member}").
            to_return(:body => "", :status => 204, :headers => {:user_agent => github.user_agent})
        public_member = github.orgs.public_member? org, member
        public_member.should be_true
      end
    end

    context "without org name and member name passed" do
      it "should fail validation " do
        expect { github.orgs.public_member?(nil, nil) }.to raise_error(ArgumentError)
      end
    end
  end # public_member?

  describe "publicize" do
    context "request perfomed successfully" do
      before do
        stub_put("/orgs/#{org}/public_members/#{member}").
          to_return(:body => fixture('orgs/members.json'), :status => 204, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without org name" do
        expect { github.orgs.publicize }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.orgs.publicize org, member
        a_put("/orgs/#{org}/public_members/#{member}").should have_been_made
      end
    end

    context "resource not found" do
      before do
        stub_put("/orgs/#{org}/public_members/#{member}").
          to_return(:body => fixture('orgs/members.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.orgs.publicize org, member
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # publicize

  describe "conceal" do
    context "request perfomed successfully" do
      before do
        stub_delete("/orgs/#{org}/public_members/#{member}").
          to_return(:body => fixture('orgs/members.json'), :status => 204, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without org name" do
        expect { github.orgs.conceal nil, nil }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.orgs.conceal org, member
        a_delete("/orgs/#{org}/public_members/#{member}").should have_been_made
      end
    end

    context "resource not found" do
      before do
        stub_delete("/orgs/#{org}/public_members/#{member}").
          to_return(:body => fixture('orgs/members.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.orgs.conceal org, member
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # conceal

  describe "delete_member" do
    let(:hook_id) { 1 }

    context "resource deleted successfully" do
      before do
        stub_delete("/orgs/#{org}/members/#{member}").
          to_return(:body => '', :status => 204, :headers => { :content_type => "application/json; charset=utf-8"})
      end

      it "should fail to delete without org and member parameters" do
        expect { github.repos.delete_hook nil, nil }.to raise_error(ArgumentError)
      end

      it "should delete the resource" do
        github.orgs.delete_member org, member
        a_delete("/orgs/#{org}/members/#{member}").should have_been_made
      end
    end

    context "failed to edit resource" do
      before do
        stub_delete("/orgs/#{org}/members/#{member}").
          to_return(:body => '', :status => 404, :headers => { :content_type => "application/json; charset=utf-8"})

      end

      it "should fail to find resource" do
        expect {
          github.orgs.delete_member org, member
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # delete_member

end # Github::Orgs::Members
