# encoding: utf-8

require 'spec_helper'

describe Github::Client::Orgs::Members, '#conceal' do
  let(:org)    { 'github' }
  let(:user) { 'peter-murach' }
  let(:request_path) { "/orgs/#{org}/public_members/#{user}" }

  before {
    stub_delete(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "request perfomed successfully" do
    let(:body) { fixture('orgs/members.json') }
    let(:status) { 204 }

    it "should fail to get resource without org name" do
      expect { subject.conceal }.to raise_error(ArgumentError)
    end

    it { expect { subject.conceal org }.to raise_error(ArgumentError) }

    it "should get the resources" do
      subject.conceal org, user
      a_delete(request_path).should have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.conceal org, user }
  end
end # conceal
