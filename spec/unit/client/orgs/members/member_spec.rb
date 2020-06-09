# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Orgs::Members, '#member?' do
  let(:org)    { 'github' }
  let(:member) { 'peter-murach' }
  let(:body) { "" }

  before do
    stub_get(request_path).to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  end

  after { reset_authentication_for(subject) }

  context "when private" do
    let(:request_path) { "/orgs/#{org}/members/#{member}" }

    context "this repo is being watched by the user" do
      let(:status) { 404 }

      it { expect { subject.member? }.to raise_error(ArgumentError) }

      it "fails validation " do
        expect { subject.member?(org)  }.to raise_error(ArgumentError)
      end

      it "returns false if resource not found" do
        membership = subject.member?(org, member)
        expect(membership).to be false
      end
    end

    context 'user is member of an organization' do
      let(:status) { 204 }

      it "returns true if resoure found" do
        membership = subject.member?(org, member)
        expect(membership).to be true
      end
    end
  end

  context 'when public' do
    let(:request_path) { "/orgs/#{org}/public_members/#{member}" }

    context "this repo is being watched by the user" do
      let(:status) { 404 }

      it "should return false if resource not found" do
        public_member = subject.member?(org, member, public: true)
        expect(public_member).to be false
      end
    end

    context 'user is member of an organization' do
      let(:status) { 204 }

      it "returns true if resoure found" do
        public_member = subject.member?(org, member, public: true)
        expect(public_member).to be true
      end
    end
  end
end # member?
