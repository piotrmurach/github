# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Orgs::Members, '#list' do
  let(:org) { 'github' }
  let(:body) { fixture('orgs/members.json') }
  let(:status) { 200 }

  before do
    stub_get(request_path).to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  end

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:request_path) { "/orgs/#{org}/members" }

    it { is_expected.to respond_to :all }

    it "fails to get resource without org name" do
      expect { subject.list }.to raise_error(ArgumentError)
    end

    it "gets the resources" do
      subject.list(org)
      expect(a_get(request_path)).to have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list org }
    end

    it "gets members information" do
      members = subject.list(org)
      expect(members.first.login).to eq('octocat')
    end

    it "yields to a block" do
      yielded = []
      result = subject.list(org) { |obj| yielded << obj }
      expect(yielded).to eq(result)
    end

    it_should_behave_like 'request failure' do
      let(:requestable) { subject.list org }
    end
  end

  context "resource found" do
    let(:request_path) { "/orgs/#{org}/public_members" }

    it "fails to get resource without org name" do
      expect { subject.list }.to raise_error(ArgumentError)
    end

    it "gets the resources" do
      subject.list(org, public: true)
      expect(a_get(request_path)).to have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list org, :public => true }
    end

    it "gets public_members information" do
      public_members = subject.list(org, public: true)
      expect(public_members.first.login).to eq('octocat')
    end

    it "yields to a block" do
      yielded = []
      result = subject.list(org, public: true) { |obj| yielded << obj }
      expect(yielded).to eq(result)
    end

    it_should_behave_like 'request failure' do
      let(:requestable) { subject.list org, public: true }
    end
  end
end # list
