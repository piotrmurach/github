# encoding: utf-8

require 'spec_helper'

describe Github::Repos, '#list' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/user/repos?access_token=#{OAUTH_TOKEN}" }
  let(:body)   { fixture('repos/repos.json') }
  let(:status) { 200 }

  after { reset_authentication_for subject }

  it { should respond_to(:find) }

  context "resource found for authenticated user" do
    before {
      subject.oauth_token = OAUTH_TOKEN
      stub_get(request_path).to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"} )
      stub_get(request_path + "&sort=pushed").
        to_return(:body => fixture('repos/repos_sorted_by_pushed.json'), :status => 200,:headers => {:content_type => "application/json; charset=utf-8"} )
    }

    it "fails if user is unauthenticated" do
      subject.oauth_token = nil
      stub_get("/user/repos").to_return(:body => '', :status => 401,
        :headers => {:content_type => "application/json; charset=utf-8"} )
      expect { subject.list }.to raise_error(Github::Error::Unauthorized)
    end

    it "should get the resources" do
      subject.list
      a_get(request_path).should have_been_made
    end

    it "should return array of resources" do
      repositories = subject.list
      repositories.should be_an Array
      repositories.should have(1).items
    end

    it "should return array of resources sorted by pushed_at time" do
      repositories = subject.list(:sort => 'pushed')
      repositories.first.name.should == "Hello-World-2"
    end

    it "should get resource information" do
      repositories = subject.list
      repositories.first.name.should == 'Hello-World'
    end

    it "should yield repositories to a block" do
      subject.should_receive(:list).and_yield('octocat')
      subject.list { |repo| 'octocat' }
    end
  end

  context "resource found for organization" do
    let(:org) { '37signals' }
    let(:request_path) { "/orgs/#{org}/repos" }

    before {
      stub_get(request_path).to_return(:body => body, :status => status,
          :headers => {:content_type => "application/json; charset=utf-8"} )
    }

    it "should get the resources" do
      subject.list :org => org
      a_get(request_path).should have_been_made
    end
  end

  context "resource found for organization" do
    let(:request_path) { "/users/#{user}/repos" }

    before {
      stub_get(request_path).to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"} )
    }

    it "should get the resources" do
      subject.list :user => user
      a_get(request_path).should have_been_made
    end
  end

  context "rosource not found for authenticated user" do
    before {
      subject.oauth_token = OAUTH_TOKEN
      stub_get(request_path).to_return(:body => '', :status => 404,
          :headers => {:content_type => "application/json; charset=utf-8"} )
    }

    it "fail to find resources" do
      expect { subject.list }.to raise_error(Github::Error::NotFound)
    end
  end
end # list
