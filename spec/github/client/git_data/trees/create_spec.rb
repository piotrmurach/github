# encoding: utf-8

require 'spec_helper'

describe Github::Client::GitData::Trees, '#create' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:sha) { "9fb037999f264ba9a7fc6274d15fa3ae2ab98312" }
  let(:request_path) { "/repos/#{user}/#{repo}/git/trees" }

  before {
    stub_post(request_path).with(inputs).
      to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  let(:inputs) {
    {
      "tree" => [
        {
          "path" => "file.rb",
          "mode" => "100644",
          "type" =>  "blob",
          "sha" => "44b4fc6d56897b048c772eb4087f854f46256132"
        }
      ]
    }
  }

  context "resouce created" do
    let(:body) { fixture('git_data/tree.json') }
    let(:status) { 201 }

    it "should fail to create resource if 'content' input is missing" do
      expect {
        subject.create user, repo, inputs.except('tree')
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should create resource successfully" do
      subject.create user, repo, inputs
      a_post(request_path).with(inputs).should have_been_made
    end

    it "should return the resource" do
      tree_sha = subject.create user, repo, inputs
      tree_sha.should be_a Github::ResponseWrapper
    end

    it "should not erase the tree data while evaluating params" do
      original_tree = inputs['tree'].dup
      tree_sha = subject.create user, repo, inputs
      inputs['tree'].should == original_tree
    end

    it "should get the tree information" do
      tree_sha = subject.create user, repo, inputs
      tree_sha.sha.should == sha
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create user, repo, inputs }
  end

end # create
