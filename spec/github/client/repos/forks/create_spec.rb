# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Forks, '#create' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/forks" }
  let(:inputs) { {:org => 'github'} }

  before {
    stub_post(request_path).with(body: inputs).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce created" do
    let(:body)   { fixture('repos/fork.json') }
    let(:status) { 202 }

    it { expect { subject.create user }.to raise_error(ArgumentError) }

    it "should create resource successfully" do
      subject.create(user, repo, inputs)
      expect(a_post(request_path).with(body: inputs)).to have_been_made
    end

    it "should return the resource" do
      fork = subject.create user, repo, inputs
      expect(fork).to be_a Github::ResponseWrapper
    end

    it "should get the fork information" do
      fork = subject.create user, repo, inputs
      expect(fork.name).to eq 'Hello-World'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create user, repo, inputs }
  end
end # create
