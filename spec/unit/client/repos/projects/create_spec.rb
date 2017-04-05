# frozen_string_literal: true

require 'spec_helper'

describe Github::Client::Repos::Projects, '#create' do
  let(:owner) { 'octocat' }
  let(:repo) { 'api-playground' }
  let(:inputs) do
    {
      :name => 'Projects Documentation',
      :body => 'Developer documentation project for the developer site.'
    }
  end

  before {
    stub_post(request_path).with(body: inputs).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"} )
  }

  context "resource created successfully" do
    let(:body)   { fixture('projects/project.json') }
    let(:status) { 201 }

    let(:request_path) { "/repos/#{owner}/#{repo}/projects" }

    it "should fail to create resource if 'name' inputs is missing" do
      expect {
        subject.create owner, repo, inputs.except(:name)
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should create resource" do
      subject.create owner, repo, inputs
      expect(a_post(request_path).with(body: inputs)).to have_been_made
    end

    it "should return the resource" do
      project = subject.create owner, repo, inputs
      expect(project.name).to eq 'Projects Documentation'
    end

    it "should return mash type" do
      project = subject.create owner, repo, inputs
      expect(project).to be_a Github::ResponseWrapper
    end
  end
end # create
