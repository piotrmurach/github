# encoding: utf-8

require 'spec_helper'

describe Github::Activity::Starring, '#list' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/stargazers" }

  after { reset_authentication_for subject }

  before {
    stub_get(request_path).
      to_return(:body => body, :status => status, :headers => {})
  }

  context 'resource found' do
    let(:body) { fixture("repos/stargazers.json") }
    let(:status) { 200 }

    it { should respond_to :all }

    it "should fail to get resource without username" do
      expect { subject.list }.to raise_error(ArgumentError)
    end

    it "should yield iterator if block given" do
      subject.should_receive(:list).with(user, repo).and_yield('github')
      subject.list(user, repo) { |param| 'github' }
    end

    it "should get the resources" do
      subject.list user, repo
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      def requestable
        subject.list user, repo
      end
    end

    it "should get watcher information" do
      stargazers = subject.list user, repo
      stargazers.first.login.should == 'octocat'
    end

    context "fail to find resource" do
      let(:body) { '' }
      let(:status) { 404 }

      it "should return 404 not found message" do
        expect {
          subject.list user, repo
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end
end # list
