# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Statuses, '#create' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:sha) { 'f5f71ce1b7295c31f091be1654618c7ec0cc6b71' }
  let(:request_path) { "/repos/#{user}/#{repo}/statuses/#{sha}" }
  let(:inputs) {
    {
      'state' => 'success'
    }
  }

  before {
    stub_post(request_path).with(inputs.except('unrelated')).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource created" do
    let(:body) { fixture('repos/status.json') }
    let(:status) { 201 }

    it { expect { subject.create user, repo }.to raise_error(ArgumentError) }

    it "should fail to create resource if 'state' input is missing" do
      expect {
        subject.create user, repo, sha, inputs.except('state')
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should create resource successfully" do
      subject.create user, repo, sha, inputs
      a_post(request_path).with(inputs).should have_been_made
    end

    it "should return the resource" do
      status = subject.create user, repo, sha, inputs
      status.should be_a Github::ResponseWrapper
    end

    it "should get the status information" do
      status = subject.create user, repo, sha, inputs
      status.state.should == 'success'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create user, repo, sha, inputs }
  end

end # create
