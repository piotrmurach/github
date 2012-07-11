require 'spec_helper'

describe Github::PullRequests do
  let(:github) { Github.new }
  let(:user)   { 'peter-murach' }
  let(:repo) { 'github' }
  let(:pull_request_id) { 1 }

  after { reset_authentication_for github }

  describe "#list" do
    it { github.pull_requests.should respond_to :all }

    context 'resource found' do
      let(:inputs) { { 'state'=> 'closed', 'unrelated' => true } }

      before do
        stub_get("/repos/#{user}/#{repo}/pulls").
          with(:query => inputs.except('unrelated')).
          to_return(:body => fixture('pull_requests/pull_requests.json'),
            :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "throws error if pull_request id not provided" do
        expect { github.pull_requests.list nil}.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.pull_requests.list user, repo, inputs
        a_get("/repos/#{user}/#{repo}/pulls").with(:query => inputs).should have_been_made
      end

      it "should return array of resources" do
        pull_requests = github.pull_requests.list user, repo, inputs
        pull_requests.should be_an Array
        pull_requests.should have(1).items
      end

      it "should be a mash type" do
        pull_requests = github.pull_requests.list user, repo, inputs
        pull_requests.first.should be_a Hashie::Mash
      end

      it "should get pull request information" do
        pull_requests = github.pull_requests.list user, repo, inputs
        pull_requests.first.title.should == 'new-feature'
      end

      it "should yield to a block" do
        github.pull_requests.should_receive(:list).with(user, repo).
          and_yield('web')
        github.pull_requests.list(user, repo) { |param| 'web' }
      end
    end

    context 'resource not found' do
      before do
        stub_get("/repos/#{user}/#{repo}/pulls").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.pull_requests.list user, repo
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # list

  describe "#get" do
    it { github.pull_requests.should respond_to :find }

    context 'resource found' do
      before do
        stub_get("/repos/#{user}/#{repo}/pulls/#{pull_request_id}").
          to_return(:body => fixture('pull_requests/pull_request.json'),
          :status => 200,
          :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without pull_request id" do
        expect { github.pull_requests.get nil }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.pull_requests.get user, repo, pull_request_id
        a_get("/repos/#{user}/#{repo}/pulls/#{pull_request_id}").
          should have_been_made
      end

      it "should get pull_request information" do
        pull_request = github.pull_requests.get user, repo, pull_request_id
        pull_request.number.should eq pull_request_id
        pull_request.head.user.login.should == 'octocat'
      end

      it "should return mash" do
        pull_request = github.pull_requests.get user, repo, pull_request_id
        pull_request.should be_a Hashie::Mash
      end
    end

    context 'resource not found' do
      before do
        stub_get("/repos/#{user}/#{repo}/pulls/#{pull_request_id}").
          to_return(:body => fixture('pull_requests/pull_request.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.pull_requests.get user, repo, pull_request_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # get

  describe "#create" do
    let(:inputs) {
      {
       "title" => "Amazing new feature",
       "body" => "Please pull this in!",
       "head" => "octocat:new-feature",
       "base" => "master",
       "state" => "open",
       'unrelated' => 'giberrish'
      }
    }

    context "resouce created" do
      before do
        stub_post("/repos/#{user}/#{repo}/pulls").
          with(inputs.except('unrelated')).
          to_return(:body => fixture('pull_requests/pull_request.json'), :status => 201, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should create resource successfully" do
        github.pull_requests.create user, repo, inputs
        a_post("/repos/#{user}/#{repo}/pulls").with(inputs).should have_been_made
      end

      it "should return the resource" do
        pull_request = github.pull_requests.create user, repo, inputs
        pull_request.should be_a Hashie::Mash
      end

      it "should get the request information" do
        pull_request = github.pull_requests.create user, repo, inputs
        pull_request.title.should eql "new-feature"
      end
    end

    context "failed to create resource" do
      before do
        stub_post("/repos/#{user}/#{repo}/pulls").with(inputs).
          to_return(:body => fixture('pull_requests/pull_request.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should faile to retrieve resource" do
        expect {
          github.pull_requests.create user, repo, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # create

  describe "#update" do
    let(:inputs) {
      {
        "title" => "new title",
        "body" => "updated body",
        "state" => "open",
        "unrelated" => true
      }
    }

    context "resouce updateed" do
      before do
        stub_patch("/repos/#{user}/#{repo}/pulls/#{pull_request_id}").
          with(inputs.except('unrelated')).
          to_return(:body => fixture('pull_requests/pull_request.json'),
            :status => 201,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should create resource successfully" do
        github.pull_requests.update user, repo, pull_request_id, inputs
        a_patch("/repos/#{user}/#{repo}/pulls/#{pull_request_id}").with(inputs).
          should have_been_made
      end

      it "should return the resource" do
        pull_request = github.pull_requests.update user, repo, pull_request_id, inputs
        pull_request.should be_a Hashie::Mash
      end

      it "should get the pull_request information" do
        pull_request = github.pull_requests.update user, repo, pull_request_id, inputs
        pull_request.title.should == 'new-feature'
      end
    end

    context "failed to create resource" do
      before do
        stub_patch("/repos/#{user}/#{repo}/pulls/#{pull_request_id}").
          with(inputs).
          to_return(:body => fixture('pull_requests/pull_request.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should faile to retrieve resource" do
        expect {
          github.pull_requests.update user, repo, pull_request_id, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # update

  describe "#commits" do
    context 'resource found' do
      before do
        stub_get("/repos/#{user}/#{repo}/pulls/#{pull_request_id}/commits").
          to_return(:body => fixture('pull_requests/commits.json'),
            :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "throws error if pull_request_id not provided" do
        expect {
          github.pull_requests.commits user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.pull_requests.commits user, repo, pull_request_id
        a_get("/repos/#{user}/#{repo}/pulls/#{pull_request_id}/commits").
          should have_been_made
      end

      it "should return array of resources" do
        pull_requests = github.pull_requests.commits user, repo, pull_request_id
        pull_requests.should be_an Array
        pull_requests.should have(1).items
      end

      it "should be a mash type" do
        pull_requests = github.pull_requests.commits user, repo, pull_request_id
        pull_requests.first.should be_a Hashie::Mash
      end

      it "should get pull request information" do
        pull_requests = github.pull_requests.commits user, repo, pull_request_id
        pull_requests.first.committer.name.should == 'Scott Chacon'
      end

      it "should yield to a block" do
        github.pull_requests.should_receive(:commits).
          with(user, repo, pull_request_id).and_yield('web')
        github.pull_requests.commits(user, repo, pull_request_id) {|param| 'web' }
      end
    end

    context 'resource not found' do
      before do
        stub_get("/repos/#{user}/#{repo}/pulls/#{pull_request_id}/commits").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.pull_requests.commits user, repo, pull_request_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # commits

  describe "#files" do
    it { github.pull_requests.should respond_to :files }

    context 'resource found' do
      before do
        stub_get("/repos/#{user}/#{repo}/pulls/#{pull_request_id}/files").
          to_return(:body => fixture('pull_requests/files.json'),
            :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the resources" do
        github.pull_requests.files user, repo, pull_request_id
        a_get("/repos/#{user}/#{repo}/pulls/#{pull_request_id}/files").
          should have_been_made
      end

      it "should return array of resources" do
        pull_requests = github.pull_requests.files user, repo, pull_request_id
        pull_requests.should be_an Array
        pull_requests.should have(1).items
      end

      it "should be a mash type" do
        pull_requests = github.pull_requests.files user, repo, pull_request_id
        pull_requests.first.should be_a Hashie::Mash
      end

      it "should get pull request information" do
        pull_requests = github.pull_requests.files user, repo, pull_request_id
        pull_requests.first.filename.should == 'file1.txt'
      end

      it "should yield to a block" do
        github.pull_requests.should_receive(:files).with(user, repo, pull_request_id).
          and_yield('web')
        github.pull_requests.files(user, repo, pull_request_id) { |param| 'web' }
      end
    end

    context 'resource not found' do
      before do
        stub_get("/repos/#{user}/#{repo}/pulls/#{pull_request_id}/files").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.pull_requests.files user, repo, pull_request_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # files

  describe "#merged?" do
    context "checks whetehr pull request has been merged" do
      before do
        github.oauth_token = nil
        github.user = nil
        stub_get("/repos/#{user}/#{repo}/pulls/#{pull_request_id}/merge").
          to_return(:body => "", :status => 404, :headers => {:user_agent => github.user_agent})
      end

      it "should fail validation " do
        expect {
          github.pull_requests.merged?(nil, nil, pull_request_id)
        }.to raise_error(ArgumentError)
      end

      it "should return false if resource not found" do
        merged = github.pull_requests.merged? user, repo, pull_request_id
        merged.should be_false
      end

      it "should return true if resoure found" do
        stub_get("/repos/#{user}/#{repo}/pulls/#{pull_request_id}/merge").
          to_return(:body => "", :status => 200,
                    :headers => {:user_agent => github.user_agent})
        merged = github.pull_requests.merged? user, repo, pull_request_id
        merged.should be_true
      end
    end
  end # merged?

  describe "#merge" do
    context 'successful' do
      before do
        stub_put("/repos/#{user}/#{repo}/pulls/#{pull_request_id}/merge").
          to_return(:body => fixture('pull_requests/merge_success.json'),
                    :status => 200,
                    :headers => {:user_agent => github.user_agent})
      end

      it 'performs request' do
        github.pull_requests.merge user, repo, pull_request_id
        a_put("/repos/#{user}/#{repo}/pulls/#{pull_request_id}/merge").
          should have_been_made
      end

      it 'response contains merge success flag' do
        response = github.pull_requests.merge(user, repo, pull_request_id)
        response.merged.should be_true
      end
    end

    context 'cannot be performed' do
      before do
        stub_put("/repos/#{user}/#{repo}/pulls/#{pull_request_id}/merge").
          to_return(:body => fixture('pull_requests/merge_failure.json'),
                    :status => 200,
                    :headers => {:user_agent => github.user_agent})

      end

      it 'response contains merge failure flag' do
        response = github.pull_requests.merge(user, repo, pull_request_id)
        response.merged.should be_false
      end
    end
  end # merge

end # Github::PullRequests
