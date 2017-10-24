# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Keys, '#get' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:key_id) { 1 }
  let(:request_path) { "/repos/#{user}/#{repo}/keys/#{key_id}" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body) { fixture("repos/key.json") }
    let(:status) { 200 }

    it { should respond_to :find }

    it { expect { subject.get }.to raise_error(ArgumentError) }

    it "should fail to get resource without key" do
      expect { subject.get user, repo }.to raise_error(ArgumentError)
    end

    it "should get the resource" do
      subject.get user, repo, key_id
      a_get(request_path).should have_been_made
    end

    it "should get key information" do
      key = subject.get user, repo, key_id
      key.id.should == key_id
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get user, repo, key_id }
  end
end # get
