# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Downloads, '#delete' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:download_id) { 1 }
  let(:request_path) { "/repos/#{user}/#{repo}/downloads/#{download_id}" }

  after { reset_authentication_for(subject) }

  before do
    stub_delete(request_path).
      to_return(:body => body, :status => status,
        :headers => { :content_type => "application/json; charset=utf-8"})
  end

  context "resource deleted successfully" do
    let(:body)   { "" }
    let(:status) { 204 }

    it { should respond_to :remove }

    it { expect { subject.delete }.to raise_error(ArgumentError) }

    it "should fail to delete without 'user/repo' parameters" do
      expect { subject.delete user }.to raise_error(ArgumentError)
    end

    it "should fail to delete resource without 'download_id'" do
      expect { subject.delete user, repo }.to raise_error(ArgumentError)
    end

    it "should delete the resource" do
      subject.delete user, repo, download_id
      a_delete(request_path).should have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.delete user, repo, download_id }
  end
end # delete
