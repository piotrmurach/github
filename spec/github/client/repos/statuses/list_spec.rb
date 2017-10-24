# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Statuses, '#list' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:sha) { 'f5f71ce1b7295c31f091be1654618c7ec0cc6b71' }
  let(:request_path) { "/repos/#{user}/#{repo}/commits/#{sha}/statuses" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body) { fixture('repos/statuses.json') }
    let(:status) { 200 }

    it { should respond_to :all }

    it "should fail to get resource without sha" do
      expect { subject.list user, repo }.to raise_error(ArgumentError)
    end

    it "should get the resources" do
      subject.list user, repo, sha
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list user, repo, sha }
    end

    it "should get status information" do
      statuses = subject.list user, repo, sha
      statuses.first.state.should == 'success'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list(user, repo, sha) { |obj| yielded << obj }
      yielded.should == result
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.list user, repo, sha }
  end

end # list
