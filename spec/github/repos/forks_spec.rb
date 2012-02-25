require 'spec_helper'

describe Github::Repos::Forks, :type => :base do

  describe "forks" do

    it { github.repos.should respond_to :forks }
    it { github.repos.should respond_to :repo_forks }
    it { github.repos.should respond_to :repository_forks }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/forks").
          to_return(:body => fixture('repos/forks.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without username" do
        github.user, github.repo = nil, nil
        expect { github.repos.forks }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.repos.forks user, repo
        a_get("/repos/#{user}/#{repo}/forks").should have_been_made
      end

      it "should return array of resources" do
        forks = github.repos.forks user, repo
        forks.should be_an Array
        forks.should have(1).items
      end

      it "should be a mash type" do
        forks = github.repos.forks user, repo
        forks.first.should be_a Hashie::Mash
      end

      it "should get fork information" do
        forks = github.repos.forks user, repo
        forks.first.name.should == 'Hello-World'
      end

      it "should yield to a block" do
        github.repos.should_receive(:forks).with(user, repo).and_yield('web')
        github.repos.forks(user, repo) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/forks").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.repos.forks user, repo
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # forks

  describe "create_hook" do
    let(:inputs) { {:org => 'github'} }

    context "resouce created" do
      before do
        stub_post("/repos/#{user}/#{repo}/forks").with(inputs).
          to_return(:body => fixture('repos/fork.json'), :status => 201, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should create resource successfully" do
        github.repos.create_fork(user, repo, inputs)
        a_post("/repos/#{user}/#{repo}/forks").with(inputs).should have_been_made
      end

      it "should return the resource" do
        fork = github.repos.create_fork user, repo, inputs
        fork.should be_a Hashie::Mash
      end

      it "should get the fork information" do
        fork = github.repos.create_fork(user, repo, inputs)
        fork.name.should == 'Hello-World'
      end
    end

    context "failed to create resource" do
      before do
        stub_post("/repos/#{user}/#{repo}/forks").with(inputs).
          to_return(:body => fixture('repos/fork.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should faile to retrieve resource" do
        expect {
          github.repos.create_fork user, repo, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # create_fork

end # Github::Repos::Forks
