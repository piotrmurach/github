# encoding: utf-8

require 'spec_helper'

describe Github::Repos::Statuses do
  let(:github) { Github.new }
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:sha) { 'f5f71ce1b7295c31f091be1654618c7ec0cc6b71' }

  after { github.user, github.repo, github.oauth_token = nil, nil, nil }

  it { described_class::VALID_STATUS_PARAM_NAMES.should_not be_nil }
  it { described_class::REQUIRED_PARAMS.should_not be_nil }

  describe "#list" do
    it { github.repos.statuses.should respond_to :all }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/statuses/#{sha}").
          to_return(:body => fixture('repos/statuses.json'), :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without sha" do
        expect { github.repos.statuses.list }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.repos.statuses.list user, repo, sha
        a_get("/repos/#{user}/#{repo}/statuses/#{sha}").should have_been_made
      end

      it "should return array of resources" do
        statuses = github.repos.statuses.list user, repo, sha
        statuses.should be_an Array
        statuses.should have(1).items
      end

      it "should be a mash type" do
        statuses = github.repos.statuses.list user, repo, sha
        statuses.first.should be_a Hashie::Mash
      end

      it "should get status information" do
        statuses = github.repos.statuses.list user, repo, sha
        statuses.first.state.should == 'success'
      end

      it "should yield to a block" do
        github.repos.statuses.should_receive(:list).with(user, repo, sha).and_yield('web')
        github.repos.statuses.list(user, repo, sha) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/statuses/#{sha}").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.repos.statuses.list user, repo, sha
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # list

  describe "#create" do
    let(:inputs) {
      {
        'state' => 'success'
      }
    }

    context "resource created" do
      before do
        stub_post("/repos/#{user}/#{repo}/statuses/#{sha}").
          with(inputs.except('unrelated')).
          to_return(:body => fixture('repos/status.json'),
            :status => 201,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to create resource if 'state' input is missing" do
        expect {
          github.repos.statuses.create user, repo, sha, inputs.except('state')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should create resource successfully" do
        github.repos.statuses.create user, repo, sha, inputs
        a_post("/repos/#{user}/#{repo}/statuses/#{sha}").with(inputs).should have_been_made
      end

      it "should return the resource" do
        status = github.repos.statuses.create user, repo, sha, inputs
        status.should be_a Hashie::Mash
      end

      it "should get the status information" do
        status = github.repos.statuses.create user, repo, sha, inputs
        status.state.should == 'success'
      end
    end

    context "fail to create resource" do
      before do
        stub_post("/repos/#{user}/#{repo}/statuses/#{sha}").with(inputs).
          to_return(:body => fixture('repos/status.json'), :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrieve resource" do
        expect {
          github.repos.statuses.create user, repo, sha, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # create

end # Github::Repos::Statuses
