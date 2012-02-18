require 'spec_helper'

describe Github::PullRequests, :type => :base do

  describe "#pull_requests" do
    context 'check aliases' do
      it { github.pull_requests.should respond_to :pulls }
      it { github.pull_requests.should respond_to :requests }
    end

    context 'resource found' do
      let(:params) { { :state => 'closed', :unrelated => true } }

      before do
        stub_get("/repos/#{user}/#{repo}/pulls").
          with(:query => params.except(:unrelated)).
          to_return(:body => fixture('pull_requests/pull_requests.json'),
            :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "throws error if gist id not provided" do
        expect { github.pull_requests.pull_requests nil}.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.pull_requests.pull_requests user, repo, params
        a_get("/repos/#{user}/#{repo}/pulls").with(:query => params).should have_been_made
      end

      it "should return array of resources" do
        pull_requests = github.pull_requests.pull_requests user, repo, params
        pull_requests.should be_an Array
        pull_requests.should have(1).items
      end

      it "should be a mash type" do
        pull_requests = github.pull_requests.pull_requests user, repo, params
        pull_requests.first.should be_a Hashie::Mash
      end

      it "should get pull request information" do
        pull_requests = github.pull_requests.pull_requests user, repo, params
        pull_requests.first.title.should == 'new-feature'
      end

      it "should yield to a block" do
        github.pull_requests.should_receive(:pull_requests).with(user, repo).
          and_yield('web')
        github.pull_requests.pull_requests(user, repo) { |param| 'web' }
      end
    end

    context 'resource not found' do
      before do
        stub_get("/repos/#{user}/#{repo}/pulls").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.pull_requests.pull_requests user, repo
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # pull_requests

end # Github::PullRequests
