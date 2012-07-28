require 'spec_helper'

describe Github::Orgs::Members do
  let(:github) { Github.new }
  let(:member) { 'peter-murach' }
  let(:org)    { 'github' }

  after { reset_authentication_for github }

  describe "#list" do
    it { github.orgs.members.should respond_to :all }

    context "resource found" do
      before do
        stub_get("/orgs/#{org}/members").
          to_return(:body => fixture('orgs/members.json'), :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without org name" do
        expect { github.orgs.members.list nil }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.orgs.members.list org
        a_get("/orgs/#{org}/members").should have_been_made
      end

      it "should return array of resources" do
        members = github.orgs.members.list org
        members.should be_an Array
        members.should have(1).items
      end

      it "should be a mash type" do
        members = github.orgs.members.list org
        members.first.should be_a Hashie::Mash
      end

      it "should get members information" do
        members = github.orgs.members.list org
        members.first.login.should == 'octocat'
      end

      it "should yield to a block" do
        github.orgs.members.should_receive(:list).with(org).and_yield('web')
        github.orgs.members.list(org) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/orgs/#{org}/members").
          to_return(:body => '', :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.orgs.members.list org
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # list

  describe "#member?" do
    context "with username ane reponame passed" do
      context "this repo is being watched by the user"
        before do
          stub_get("/orgs/#{org}/members/#{member}").
            to_return(:body => "", :status => 404,
              :headers => {:user_agent => github.user_agent})
        end

      it "should return false if resource not found" do
        membership = github.orgs.members.member? org, member
        membership.should be_false
      end

      it "should return true if resoure found" do
          stub_get("/orgs/#{org}/members/#{member}").
            to_return(:body => "", :status => 204, :headers => {:user_agent => github.user_agent})
        membership = github.orgs.members.member? org, member
        membership.should be_true
      end
    end

    context "without org name and member name passed" do
      it "should fail validation " do
        expect {
          github.orgs.members.member?(nil, nil)
        }.to raise_error(ArgumentError)
      end
    end
  end # member?

  describe "#list_public" do
    context "resource found" do
      before do
        stub_get("/orgs/#{org}/public_members").
          to_return(:body => fixture('orgs/members.json'), :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without org name" do
        expect { github.orgs.members.list_public }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.orgs.members.list_public org
        a_get("/orgs/#{org}/public_members").should have_been_made
      end

      it "should return array of resources" do
        public_members = github.orgs.members.list_public org
        public_members.should be_an Array
        public_members.should have(1).items
      end

      it "should be a mash type" do
        public_members = github.orgs.members.list_public org
        public_members.first.should be_a Hashie::Mash
      end

      it "should get public_members information" do
        public_members = github.orgs.members.list_public org
        public_members.first.login.should == 'octocat'
      end

      it "should yield to a block" do
        github.orgs.members.should_receive(:list_public).with(org).and_yield('web')
        github.orgs.members.list_public(org) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/orgs/#{org}/public_members").
          to_return(:body => '', :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.orgs.members.list_public org
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # list_public

  describe "public_member?" do
    context "with username ane reponame passed" do
      context "this repo is being watched by the user"
        before do
          stub_get("/orgs/#{org}/public_members/#{member}").
            to_return(:body => "", :status => 404, :headers => {:user_agent => github.user_agent})
        end

      it "should return false if resource not found" do
        public_member = github.orgs.members.public_member? org, member
        public_member.should be_false
      end

      it "should return true if resoure found" do
          stub_get("/orgs/#{org}/public_members/#{member}").
            to_return(:body => "", :status => 204, :headers => {:user_agent => github.user_agent})
        public_member = github.orgs.members.public_member? org, member
        public_member.should be_true
      end
    end

    context "without org name and member name passed" do
      it "should fail validation " do
        expect {
          github.orgs.members.public_member?(nil, nil)
        }.to raise_error(ArgumentError)
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
        expect { github.orgs.members.publicize }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.orgs.members.publicize org, member
        a_put("/orgs/#{org}/public_members/#{member}").should have_been_made
      end
    end

    context "resource not found" do
      before do
        stub_put("/orgs/#{org}/public_members/#{member}").
          to_return(:body => '', :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.orgs.members.publicize org, member
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # publicize

  describe "#conceal" do
    context "request perfomed successfully" do
      before do
        stub_delete("/orgs/#{org}/public_members/#{member}").
          to_return(:body => fixture('orgs/members.json'), :status => 204,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without org name" do
        expect {
          github.orgs.members.conceal nil, nil
        }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.orgs.members.conceal org, member
        a_delete("/orgs/#{org}/public_members/#{member}").should have_been_made
      end
    end

    context "resource not found" do
      before do
        stub_delete("/orgs/#{org}/public_members/#{member}").
          to_return(:body => '', :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.orgs.members.conceal org, member
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # conceal

  describe "#delete" do
    let(:hook_id) { 1 }

    context "resource deleted successfully" do
      before do
        stub_delete("/orgs/#{org}/members/#{member}").
          to_return(:body => '', :status => 204, :headers => { :content_type => "application/json; charset=utf-8"})
      end

      it "should fail to delete without org and member parameters" do
        expect { github.orgs.members.delete nil, nil }.to raise_error(ArgumentError)
      end

      it "should delete the resource" do
        github.orgs.members.delete org, member
        a_delete("/orgs/#{org}/members/#{member}").should have_been_made
      end
    end

    context "failed to edit resource" do
      before do
        stub_delete("/orgs/#{org}/members/#{member}").
          to_return(:body => '', :status => 404,
            :headers => { :content_type => "application/json; charset=utf-8"})
      end

      it "should fail to find resource" do
        expect {
          github.orgs.members.delete org, member
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # delete

end # Github::Orgs::Members
