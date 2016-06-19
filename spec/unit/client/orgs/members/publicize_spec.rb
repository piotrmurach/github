# encoding: utf-8

require 'spec_helper'

describe Github::Client::Orgs::Members, '#publicize' do
  let(:org)    { 'github' }
  let(:member) { 'peter-murach' }
  let(:request_path) { "/orgs/#{org}/public_members/#{member}" }

  before {
    stub_put(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "request perfomed successfully" do
    let(:body) { fixture('orgs/members.json') }
    let(:status) { 204 }

    it "should fail to get resource without org name" do
      expect { subject.publicize }.to raise_error(ArgumentError)
    end

    it { expect { subject.publicize org }.to raise_error(ArgumentError) }

    it "should get the resources" do
      subject.publicize org, member
      a_put(request_path).should have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.publicize org, member }
  end
end # publicize
