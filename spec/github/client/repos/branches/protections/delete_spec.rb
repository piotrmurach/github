# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Branches::Protections, '#delete' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/branches/#{branch}/protection" }
  let(:branch) { 'master' }
  let(:body) { '' }
  let(:status) { 204 }

  before {
    stub_delete(request_path).to_return(:body => body, :status => status,
      :headers => { :content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  it { should respond_to :remove }

  it "should delete the resource successfully" do
    subject.delete user, repo, branch
    a_delete(request_path).should have_been_made
  end

  it "should fail to delete resource without 'user' parameter" do
    expect { subject.delete nil, repo, branch }.to raise_error(ArgumentError)
  end

  it "should fail to delete resource without 'repo' parameter" do
    expect { subject.delete user, nil, branch }.to raise_error(ArgumentError)
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.delete user, repo, branch }
  end
end # delete