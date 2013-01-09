require 'spec_helper'

describe Github::PullRequests do
  let(:github) { Github.new }
  let(:user)   { 'peter-murach' }
  let(:repo) { 'github' }
  let(:pull_request_id) { 1 }

  after { reset_authentication_for github }

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
          to_return(:body => "[]", :status => 404, :headers => {:user_agent => github.user_agent})
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
          to_return(:body => "[]", :status => 200,
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
