# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Collaborators, '#add' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:collaborator) { 'octocat' }
  let(:request_path) { "/repos/#{user}/#{repo}/collaborators/#{collaborator}" }

  before {
    stub_put(request_path).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce added" do
    let(:body) { '' }
    let(:status) { 204 }

    it { expect { subject.add }.to raise_error(ArgumentError) }

    it "should fail to add resource if 'collaborator' input is missing" do
      expect { subject.add user, repo }.to raise_error(ArgumentError)
    end

    it "should add resource successfully" do
      subject.add user, repo, collaborator
      a_put(request_path).should have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.add user, repo, collaborator }
  end
end # add
