# encoding: utf-8

require 'spec_helper'

describe Github::Client, '#repos' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:location) { "/repos/#{user}/changed-name" }
  let(:request_path) { "/repos/#{user}/#{repo}" }
  let(:too_many_path) { "/repos/too-many/redirects" }

  before {
    stub_get(request_path).to_return(:body => "{}", :status => 302, 
        :headers => {:content_type => "application/json; charset=utf-8", 
                     :location => location})

    stub_get(location).to_return(:body => "{}", :status => 200,
        :headers => {:content_type => "application/json; charset=utf-8"})

    #infite redirect
    stub_get(too_many_path).to_return(:body => "{}", :status => 302,
        :headers => {:content_type => "application/json; charset=utf-8",
                     :location => too_many_path
    })
  }

  after { reset_authentication_for(subject) }

  it "redirects and grabs the resource as if it was a 200" do
    subject.repos.get(user, repo)
    expect(a_get(request_path)).to have_been_made
  end

  it "throws if there are too many redirects" do
    limit_reached = Github::RedirectLimitReached
    expect{ subject.repos.get("too-many", "redirects") }.to raise_error(limit_reached)

    expect(a_get(too_many_path)).to have_been_made.times(4)
  end
end
