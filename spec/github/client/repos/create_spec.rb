# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos, '#create' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:inputs) { {
    :name => 'web',
    :description => "This is your first repo",
    :homepage => "https://github.com",
    :public => true,
    :has_issues => true,
    :has_wiki => true
  } }

  before {
    subject.oauth_token = OAUTH_TOKEN
    stub_post(request_path).with(body: inputs).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"} )
  }

  after { reset_authentication_for subject }

  context "resource created successfully" do
    let(:body)   { fixture('repos/repo.json') }
    let(:status) { 201 }

    context "for the authenticated user" do
      let(:request_path) { "/user/repos?access_token=#{OAUTH_TOKEN}" }

      it "should fail to create resource if 'name' inputs is missing" do
        expect {
          subject.create inputs.except(:name)
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should create resource" do
        subject.create inputs
        expect(a_post(request_path).with(body: inputs)).to have_been_made
      end

      it "should return the resource" do
        repository = subject.create inputs
        expect(repository.name).to eq 'Hello-World'
      end

      it "should return mash type" do
        repository = subject.create inputs
        expect(repository).to be_a Github::ResponseWrapper
      end
    end

    context "for the authenticated user belonging to organization" do
      let(:request_path) { "/orgs/#{org}/repos?access_token=#{OAUTH_TOKEN}" }
      let(:org) { '37signals' }

      it "should get the resource" do
        subject.create inputs.merge(:org => org)
        expect(a_post(request_path).with(body: inputs)).to have_been_made
      end
    end
  end

  context "failed to create" do
    let(:request_path) { "/user/repos?access_token=#{OAUTH_TOKEN}" }
    let(:body)   { '' }
    let(:status) { 404 }

    it "should faile to retrieve resource" do
      expect {
        subject.create inputs
      }.to raise_error(Github::Error::NotFound)
    end
  end
end # create
