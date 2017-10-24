# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Keys, '#delete' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/keys/#{key_id}" }
  let(:key_id) { 1 }

  before {
    stub_delete(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found successfully" do
    let(:body) { '' }
    let(:status) { 204 }

    it "should fail to delete without 'user/repo' parameters" do
      expect { subject.delete }.to raise_error(ArgumentError)
    end

    it "should fail to delete resource without key id" do
      expect { subject.delete user, repo }.to raise_error(ArgumentError)
    end

    it "should delete the resource" do
      subject.delete user, repo, key_id
      a_delete(request_path).should have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.delete user, repo, key_id }
  end
end # delete
