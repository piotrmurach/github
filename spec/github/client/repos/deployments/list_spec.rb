# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Deployments, '#list' do
  let(:user) { 'nahiluhmot' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/deployments" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body)   { fixture('repos/deployments.json') }
    let(:status) { 200 }

    it { should respond_to :all }

    it { expect { subject.list }.to raise_error(ArgumentError) }

    it { expect { subject user }.to raise_error(ArgumentError) }

    it "should get the resources" do
      subject.list user, repo
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list user, repo }
    end

    it "should get deployment information" do
      deploys = subject.list user, repo
      deploys.first.description.should == 'Test deploy'
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
