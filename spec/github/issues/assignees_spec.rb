require 'spec_helper'

describe Github::Issues::Assignees do
  let(:github) { Github::Issues::Assignees.new }
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:assignee) { 'octocat' }

  after { github.user, github.repo, github.oauth_token = nil, nil, nil }

  describe '#list' do
    context 'resources found' do
      before do
        stub_get("/repos/#{user}/#{repo}/assignees").
          to_return(:body => fixture('repos/assignees.json'),
            :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it 'should get the resources' do
        github.list user, repo
        a_get("/repos/#{user}/#{repo}/assignees").should have_been_made
      end

      it "should return array of resources" do
        assignees = github.list user, repo
        assignees.should be_an Array
        assignees.should have(1).items
      end

      it "should be a mash type" do
        assignees = github.list user, repo
        assignees.first.should be_a Hashie::Mash
      end

      it "should get collaborator information" do
        assignees = github.list user, repo
        assignees.first.login.should == 'octocat'
      end

      it "should yield to a block" do
        github.should_receive(:list).with(user, repo).and_yield('web')
        github.list(user, repo) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/assignees").
          to_return(:body => "", :status => [404, "Not Found"],
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.list user, repo
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # list

  describe '#check' do
    context "resource found " do
      before do
        stub_get("/repos/#{user}/#{repo}/assignees/#{assignee}").
          to_return(:body => '', :status => 204,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without collaborator name" do
        expect {
          github.check user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.check user, repo, assignee
        a_get("/repos/#{user}/#{repo}/assignees/#{assignee}").should have_been_made
      end

      it "should find assignee" do
        github.should_receive(:check).with(user, repo, assignee) { true }
        github.check user, repo, assignee
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/assignees/#{assignee}").
          to_return(:body => '', :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrieve resource" do
        github.should_receive(:check).with(user, repo, assignee) { false }
        github.check user, repo, assignee
      end
    end
  end # check

end # Github::Repos::Assignees
