# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Deployments, '#statuses' do
  let(:user) { 'nahiluhmot' }
  let(:repo) { 'github' }
  let(:id)     { 12147 }
  let(:request_path) { "/repos/#{user}/#{repo}/deployments/#{id}/statuses" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body)   { fixture('repos/deployments.json') }
    let(:status) { 200 }

    it { expect { subject.statuses }.to raise_error(ArgumentError) }
    it { expect { subject user }.to raise_error(ArgumentError) }

    it "should get the resources" do
      subject.statuses user, repo, id
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.statuses user, repo, id }
    end

    it "should get deployment information" do
      statuses = subject.statuses user, repo, id
      statuses.first.sha.should == 'a9a5ad01cf26b646e6f95bf9e2d13a2a155b5c9b'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.statuses(user, repo, id) { |obj| yielded << obj }
      yielded.should == result
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.statuses user, repo, id }
  end
end # list
