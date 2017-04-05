# frozen_string_literal: true

require 'spec_helper'

describe Github::Client::Orgs::Projects, '#create' do
  let(:org) { 'API-sampler' }
  let(:request_path) { "/orgs/#{org}/projects" }
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

    it "should fail to create resource if 'name' inputs is missing" do
      expect {
        subject.create org, inputs.except(:name)
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should create resource" do
      subject.create org, inputs
      expect(a_post(request_path).with(body: inputs)).to have_been_made
    end

    it "should return the resource" do
      project = subject.create org, inputs
      expect(project.name).to eq 'Projects Documentation'
    end

    it "should return mash type" do
      project = subject.create org, inputs
      expect(project).to be_a Github::ResponseWrapper
    end
  end
end # create
