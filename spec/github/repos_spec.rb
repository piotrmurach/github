require 'spec_helper'

describe Github::Repos do

  let(:github) { Github.new }
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }

  describe "branches" do
    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/branches").
          to_return(:body => fixture('repos/branches.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should raise error when no user/repo parameters" do
        github.user, github.repo = nil, nil
        expect {
          github.repos.branches
        }.to raise_error(ArgumentError, /\[user\] parameter cannot be nil/)
      end

      it "should raise error when no repository" do
        github.user, github.repo = nil, nil
        expect {
          github.repos.branches user
        }.to raise_error(ArgumentError, /\[repo\] parameter cannot be nil/)
      end

      it "should find resources" do
        github.repos.branches user, repo
        a_get("/repos/#{user}/#{repo}/branches").should have_been_made
      end

      it "should return array of resources" do
        branches = github.repos.branches user, repo
        branches.should be_an Array
        branches.should have(1).items
      end

      it "should get branch information" do
        branches = github.repos.branches user, repo
        branches.first.name.should == 'master'
      end

      it "should yield to a block" do
        github.repos.should_receive(:branches).with(user, repo).and_yield('web')
        github.repos.branches(user, repo) { |param| 'web'}
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/branches").
          to_return(:body => fixture('repos/branches.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should fail to get resource" do
        expect {
          github.repos.branches user, repo
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # branches

  describe "contributors" do
    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/contributors").
          to_return(:body => fixture('repos/contributors.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should raise error when no user/repo parameters" do
        github.user, github.repo = nil, nil
        expect {
          github.repos.contributors
        }.to raise_error(ArgumentError, /\[user\] parameter cannot be nil/)
      end

      it "should raise error when no repository" do
        github.user, github.repo = nil, nil
        expect {
          github.repos.contributors user
        }.to raise_error(ArgumentError, /\[repo\] parameter cannot be nil/)
      end

      it "should find resources" do
        github.repos.contributors user, repo
        a_get("/repos/#{user}/#{repo}/contributors").should have_been_made
      end

      it "should return array of resources" do
        contributors = github.repos.contributors user, repo
        contributors.should be_an Array
        contributors.should have(1).items
      end

      it "should get branch information" do
        contributors = github.repos.contributors user, repo
        contributors.first.login.should == 'octocat'
      end

      it "should yield to a block" do
        github.repos.should_receive(:contributors).with(user, repo).and_yield('web')
        github.repos.contributors(user, repo) { |param| 'web'}
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/contributors").
          to_return(:body => fixture('repos/contributors.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should fail to get resource" do
        expect {
          github.repos.contributors user, repo
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # contributors

  describe "edit_repo" do

  end # edit_repo

  describe "get_repo" do
    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}").
          to_return(:body => fixture('repos/repo.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should raise error when no user/repo parameters" do
        github.user, github.repo = nil, nil
        expect {
          github.repos.get_repo
        }.to raise_error(ArgumentError, /\[user\] parameter cannot be nil/)
      end

      it "should raise error when no repository" do
        github.user, github.repo = nil, nil
        expect {
          github.repos.get_repo user
        }.to raise_error(ArgumentError, /\[repo\] parameter cannot be nil/)
      end

      it "should find resources" do
        github.repos.get_repo user, repo
        a_get("/repos/#{user}/#{repo}").should have_been_made
      end

      it "should return repository mash" do
        repository = github.repos.get_repo user, repo
        repository.should be_a Hashie::Mash
      end

      it "should get repository information" do
        repository = github.repos.get_repo user, repo
        repository.name.should == 'Hello-World'
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}").
          to_return(:body => '', :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource" do
        expect {
          github.repos.get_repo user, repo
        }.to raise_error(Github::ResourceNotFound)
      end

    end
  end # get_repo

  describe "languages" do
    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/languages").
          to_return(:body => fixture('repos/languages.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should raise error when no user/repo parameters" do
        github.user, github.repo = nil, nil
        expect {
          github.repos.languages
        }.to raise_error(ArgumentError, /\[user\] parameter cannot be nil/)
      end

      it "should raise error when no repository" do
        github.user, github.repo = nil, nil
        expect {
          github.repos.languages user
        }.to raise_error(ArgumentError, /\[repo\] parameter cannot be nil/)
      end

      it "should find resources" do
        github.repos.languages user, repo
        a_get("/repos/#{user}/#{repo}/languages").should have_been_made
      end

      it "should return hash of languages" do
        languages = github.repos.languages user, repo
        languages.should be_an Hash
        languages.should have(2).keys
      end

      it "should get language information" do
        languages = github.repos.languages user, repo
        languages.keys.first.should == 'Ruby'
      end

      it "should yield to a block" do
        github.repos.should_receive(:languages).with(user, repo).and_yield('web')
        github.repos.languages(user, repo) { |param| 'web'}
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/languages").
          to_return(:body => '', :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should fail to get resource" do
        expect {
          github.repos.languages user, repo
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # languages

  describe "tags" do
    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/tags").
          to_return(:body => fixture('repos/tags.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should raise error when no user/repo parameters" do
        github.user, github.repo = nil, nil
        expect {
          github.repos.tags
        }.to raise_error(ArgumentError, /\[user\] parameter cannot be nil/)
      end

      it "should raise error when no repository" do
        github.user, github.repo = nil, nil
        expect {
          github.repos.tags user
        }.to raise_error(ArgumentError, /\[repo\] parameter cannot be nil/)
      end

      it "should find resources" do
        github.repos.tags user, repo
        a_get("/repos/#{user}/#{repo}/tags").should have_been_made
      end

      it "should return array of resources" do
        tags = github.repos.tags user, repo
        tags.should be_an Array
        tags.should have(1).items
      end

      it "should get tag information" do
        tags = github.repos.tags user, repo
        tags.first.name.should == 'v0.1'
      end

      it "should yield to a block" do
        github.repos.should_receive(:tags).with(user, repo).and_yield('web')
        github.repos.tags(user, repo) { |param| 'web'}
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/tags").
          to_return(:body => fixture('repos/branches.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should fail to get resource" do
        expect {
          github.repos.tags user, repo
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end #tags

  describe "teams" do
    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/teams").
          to_return(:body => fixture('repos/teams.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should raise error when no user/repo parameters" do
        github.user, github.repo = nil, nil
        expect {
          github.repos.teams
        }.to raise_error(ArgumentError, /\[user\] parameter cannot be nil/)
      end

      it "should raise error when no repository" do
        github.user, github.repo = nil, nil
        expect {
          github.repos.teams user
        }.to raise_error(ArgumentError, /\[repo\] parameter cannot be nil/)
      end

      it "should find resources" do
        github.repos.teams user, repo
        a_get("/repos/#{user}/#{repo}/teams").should have_been_made
      end

      it "should return array of resources" do
        teams = github.repos.teams user, repo
        teams.should be_an Array
        teams.should have(1).items
      end

      it "should get branch information" do
        teams = github.repos.teams user, repo
        teams.first.name.should == 'Owners'
      end

      it "should yield to a block" do
        github.repos.should_receive(:teams).with(user, repo).and_yield('web')
        github.repos.teams(user, repo) { |param| 'web'}
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/teams").
          to_return(:body => fixture('repos/teams.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should fail to get resource" do
        expect {
          github.repos.teams user, repo
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # teams

end # Github::Repos
