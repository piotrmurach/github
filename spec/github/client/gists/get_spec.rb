# encoding: utf-8

require 'spec_helper'

describe Github::Client::Gists, '#get' do
  let(:gist_id) { 1 }
  let(:request_path) { "/gists/#{gist_id}" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body) { fixture('gists/gist.json') }
    let(:status) { 200 }

    it { should respond_to :find }

    it "should fail to get resource without gist id" do
      expect { subject.get }.to raise_error(ArgumentError)
    end

    it "should get the resource" do
      subject.get gist_id
      a_get(request_path).should have_been_made
    end

    it "should get gist information" do
      gist = subject.get gist_id
      gist.id.to_i.should eq gist_id
      gist.user.login.should == 'octocat'
    end

    it "should return mash" do
      gist = subject.get gist_id
      gist.should be_a Github::ResponseWrapper
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get gist_id }
  end

end # get
