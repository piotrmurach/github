# encoding: utf-8

require 'spec_helper'

describe Github::Client::Orgs::Hooks, '#list' do
  let(:org) { 'API-sampler' }
  let(:request_path) { "/orgs/#{org}/hooks" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body) { fixture('orgs/hooks.json') }
    let(:status) { 200 }

    it { subject.should respond_to :all }

    it { expect { subject.list }.to raise_error(ArgumentError) }

    # it "should fail to get resource without required arguments" do
    #   expect { subject.list org }.to raise_error(ArgumentError)
    # end

    it "should get the resources" do
      subject.list org
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list org }
    end

    it "should get hook information" do
      hooks = subject.list org
      hooks.first.name.should == 'web'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list(org) { |obj| yielded << obj }
      yielded.should == result
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.list org }
  end
end # list
