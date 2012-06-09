# encoding: utf-8

require 'spec_helper'

describe Github::Orgs do
  let(:github) { Github.new }
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:org) { 'github' }

  after { reset_authentication_for github }

  context 'access to apis' do
    it { subject.members.should be_a Github::Orgs::Members }
    it { subject.teams.should be_a Github::Orgs::Teams }
  end

  describe "#list" do
    context "resource found for a user" do
      before do
        stub_get("/users/#{user}/orgs").
          to_return(:body => fixture('orgs/orgs.json'), :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the resources" do
        github.orgs.list :user => user
        a_get("/users/#{user}/orgs").should have_been_made
      end

      it "should return array of resources" do
        orgs = github.orgs.list :user => user
        orgs.should be_an Array
        orgs.should have(1).items
      end

      it "should be a mash type" do
        orgs = github.orgs.list :user => user
        orgs.first.should be_a Hashie::Mash
      end

      it "should get org information" do
        orgs = github.orgs.list :user => user
        orgs.first.login.should == 'github'
      end

      it "should yield to a block" do
        github.orgs.should_receive(:list).with(:user => user).and_yield('web')
        github.orgs.list(:user => user) { |param| 'web' }
      end
    end

    context "resource found for an au user" do
      before do
        github.oauth_token = OAUTH_TOKEN
        stub_get("/user/orgs").
          with(:query => { :access_token => OAUTH_TOKEN }).
          to_return(:body => fixture('orgs/orgs.json'), :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      # after { github.oauth_token = nil }

      it "should get the resources" do
        github.orgs.list
        a_get("/user/orgs").with(:query => { :access_token => OAUTH_TOKEN }).
          should have_been_made
      end
    end

    context "resource not found for a user" do
      before do
        stub_get("/users/#{user}/orgs").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.orgs.list :user => user
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # list

  describe "#get" do
    context "resource found" do
      before do
        stub_get("/orgs/#{org}").
          to_return(:body => fixture('orgs/org.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without org name" do
        expect { github.orgs.get }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.orgs.get org
        a_get("/orgs/#{org}").should have_been_made
      end

      it "should get org information" do
        organisation = github.orgs.get org
        organisation.id.should == 1
        organisation.login.should == 'github'
      end

      it "should return mash" do
        organisation = github.orgs.get org
        organisation.should be_a Hashie::Mash
      end
    end

    context "resource not found" do
      before do
        stub_get("/orgs/#{org}").
          to_return(:body => fixture('orgs/org.json'), :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.orgs.get org
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # get

  describe "#edit" do
    let(:inputs) do
      { :billing_email => 'support@github.com',
        :blog => "https://github.com/blog",
        :company => "GitHub",
        :email => "support@github.com",
        :location => "San Francisco",
        :name => "github" }
    end

    context "resource edited successfully" do
      before do
        stub_patch("/orgs/#{org}").with(inputs).
          to_return(:body => fixture("orgs/org.json"), :status => 200,
            :headers => { :content_type => "application/json; charset=utf-8"})
      end

      it "should fail to edit without 'user/repo' parameters" do
        expect { github.orgs.edit }.to raise_error(ArgumentError)
      end

      it "should edit the resource" do
        github.orgs.edit org
        a_patch("/orgs/#{org}").with(inputs).should have_been_made
      end

      it "should return resource" do
        organisation = github.orgs.edit org
        organisation.should be_a Hashie::Mash
      end

      it "should be able to retrieve information" do
        organisation = github.orgs.edit org
        organisation.name.should == 'github'
      end
    end

    context "failed to edit resource" do
      before do
        stub_patch("/orgs/#{org}").with(inputs).
          to_return(:body => fixture("orgs/org.json"), :status => 404,
            :headers => { :content_type => "application/json; charset=utf-8"})
      end

      it "should fail to find resource" do
        expect {
          github.orgs.edit org
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # edit

end # Github::Orgs
