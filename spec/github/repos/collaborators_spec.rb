require 'spec_helper'

describe Github::Repos::Collaborators, :type => :base do

  describe "collaborators" do
    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/collaborators").
          to_return(:body => fixture('repos/collaborators.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without username" do
        github.user, github.repo = nil, nil
        expect { github.repos.collaborators }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.repos.collaborators user, repo
        a_get("/repos/#{user}/#{repo}/collaborators").should have_been_made
      end

      it "should return array of resources" do
        collaborators = github.repos.collaborators user, repo
        collaborators.should be_an Array
        collaborators.should have(1).items
      end

      it "should be a mash type" do
        collaborators = github.repos.collaborators user, repo
        collaborators.first.should be_a Hashie::Mash
      end

      it "should get collaborator information" do
        collaborators = github.repos.collaborators user, repo
        collaborators.first.login.should == 'octocat'
      end

      it "should yield to a block" do
        github.repos.should_receive(:collaborators).with(user, repo).and_yield('web')
        github.repos.collaborators(user, repo) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/collaborators").
          to_return(:body => "", :status => [404, "Not Found"], :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.repos.collaborators user, repo
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # collaborators


  describe "collaborator?" do
    context "resource found " do
      before do
        stub_get("/repos/#{user}/#{repo}/collaborators/#{collaborator}").
          to_return(:body => '', :status => 204, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without collaborator name" do
        expect {
          github.repos.collaborator?(user, repo, nil)
        }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.repos.collaborator? user, repo, collaborator
        a_get("/repos/#{user}/#{repo}/collaborators/#{collaborator}").should have_been_made
      end

      it "should find collaborator" do
        github.repos.should_receive(:collaborator?).with(user, repo, collaborator).and_return true
        github.repos.collaborator? user, repo, collaborator
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/collaborators/#{collaborator}").
          to_return(:body => '', :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrieve resource" do
        github.repos.should_receive(:collaborator?).with(user, repo, collaborator).and_return false
        github.repos.collaborator? user, repo, collaborator
      end
    end
  end # collaborator?

  describe "add_collaborator" do

    context "resouce added" do
      before do
        stub_put("/repos/#{user}/#{repo}/collaborators/#{collaborator}").
          to_return(:body => '', :status => 204, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to add resource if 'collaborator' input is missing" do
        expect {
          github.repos.add_collaborator user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should add resource successfully" do
        github.repos.add_collaborator user, repo, collaborator
        a_put("/repos/#{user}/#{repo}/collaborators/#{collaborator}").should have_been_made
      end
    end

    context "failed to add resource" do
      before do
        stub_put("/repos/#{user}/#{repo}/collaborators/#{collaborator}").
          to_return(:body => '', :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to add resource" do
        expect {
          github.repos.add_collaborator user, repo, collaborator
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # add_collaborator

  describe "remove_collaborator" do

    context "resouce added" do
      before do
        stub_delete("/repos/#{user}/#{repo}/collaborators/#{collaborator}").
          to_return(:body => '', :status => 204, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to add resource if 'collaborator' input is missing" do
        expect {
          github.repos.remove_collaborator user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should add resource successfully" do
        github.repos.remove_collaborator user, repo, collaborator
        a_delete("/repos/#{user}/#{repo}/collaborators/#{collaborator}").should have_been_made
      end
    end

    context "failed to remove resource" do
      before do
        stub_delete("/repos/#{user}/#{repo}/collaborators/#{collaborator}").
          to_return(:body => '', :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to remove resource" do
        expect {
          github.repos.remove_collaborator user, repo, collaborator
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # remove_collaborator

end # Github::Repos::Collaborators
