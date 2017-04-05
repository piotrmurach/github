# frozen_string_literal: true

require 'spec_helper'
require 'pry'

describe Github::Client::Repos::Projects, '#list' do
  let(:user) { 'samphilipd' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/projects" }

  before {
    stub_get(request_path)
      .with(headers: {'Accept'=>'application/vnd.github.inertia-preview+json'})
      .to_return(
        body: body,
        status: status,
        headers: {
          content_type: "application/json; charset=utf-8"
        }
      )
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body)   { fixture('repos/projects.json') }
    let(:status) { 200 }

    it { should respond_to :all }

    it { expect { subject.list }.to raise_error(ArgumentError) }

    it "should fail to get resource without username" do
      expect { subject.list user }.to raise_error(ArgumentError)
    end

    it "should get the resources" do
      subject.list user, repo
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list user, repo }
    end

    it "should get project information" do
      projects = subject.list user, repo
      projects.first.name.should == 'Implement new APIs'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list(user, repo) { |obj| yielded << obj }
      yielded.should == result
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.list user, repo }
  end
end # list
