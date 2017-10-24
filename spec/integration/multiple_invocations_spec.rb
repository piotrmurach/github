# encoding: utf-8

require 'spec_helper'

describe Github, 'invocations' do

  context 'repo commits with sha' do
    let(:user) { "peter-murach" }
    let(:repo) { "github" }
    let(:sha)  { "ceb66b61264657898cd6608c7e9ed78072169664" }

    let(:request_path) { "/repos/#{user}/#{repo}/commits/#{sha}" }

    before {
      stub_get(request_path).to_return(:body => '{}', :status => 200,
        :headers => {:content_type => "application/json; charset=utf-8"})
    }

    it 'requests commit information twice' do
      subject.repos.commits.get user, repo, sha
      subject.repos.commits.get user, repo, sha
      a_get(request_path).should have_been_made.times(2)
    end
  end

  context 'organization info' do
    let(:org)  { "thoughtbot" }

    let(:request_path) { "/orgs/#{org}" }

    before {
      stub_get(request_path).to_return(:body => '{}', :status => 200,
        :headers => {:content_type => "application/json; charset=utf-8"})
    }

    it 'requests organization information twice' do
      subject.orgs.get org
      subject.orgs.get org
      a_get(request_path).should have_been_made.times(2)
    end
  end
end
