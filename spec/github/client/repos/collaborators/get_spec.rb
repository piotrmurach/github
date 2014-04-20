# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Collaborators, '#collaborator?' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:collaborator) { 'octocat' }
  let(:request_path) { "/repos/#{user}/#{repo}/collaborators/#{collaborator}" }

  before {
    stub_get(request_path).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found " do
    let(:body) { '' }
    let(:status) { 204 }

    it "should fail to get resource without collaborator name" do
      expect { subject.collaborator? user, repo }.to raise_error(ArgumentError)
    end

    it "should get the resource" do
      subject.collaborator? user, repo, collaborator
      a_get(request_path).should have_been_made
    end

    it "should find collaborator" do
      subject.should_receive(:collaborator?).
        with(user, repo, collaborator) { true }
      subject.collaborator? user, repo, collaborator
    end
  end

  context "resource not found" do
    let(:body) { '' }
    let(:status) { 404 }

    it "should fail to retrieve resource" do
      subject.should_receive(:collaborator?).
        with(user, repo, collaborator) { false }
      subject.collaborator? user, repo, collaborator
    end
  end
end # collaborator?
