require 'spec_helper'

describe Github::Orgs::Members do
  let(:github) { Github.new }
  let(:member) { 'peter-murach' }
  let(:org)    { 'github' }

  after { reset_authentication_for github }

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
