# encoding: utf-8

require 'spec_helper'

describe Github::Client::GitData::References, '#delete' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:ref) { "heads/master" }
  let(:request_path) { "/repos/#{user}/#{repo}/git/refs/#{ref}" }

  before {
    stub_delete(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce delete" do
    let(:body) { '' }
    let(:status) { 204 }

    it { should respond_to :remove }

    it { expect { subject.delete }.to raise_error(ArgumentError) }

    it "should fail to delete resource if 'ref' input is missing" do
      expect { subject.delete user, repo }.to raise_error(ArgumentError)
    end

    it "should delete resource successfully" do
      subject.delete user, repo, ref
      a_delete(request_path).should have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.delete user, repo, ref }
  end
end # delete
