# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Orgs::Hooks, '#get' do
  let(:org) { 'API-sampler' }
  let(:hook_id) { 1 }
  let(:request_path) { "/orgs/#{org}/hooks/#{hook_id}" }

  before do
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  end

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body)  { fixture('orgs/hook.json') }
    let(:status) { 200 }

    it { expect(subject).to respond_to :find }

    it "fails to get resource without hook id" do
      expect { subject.get org }.to raise_error(ArgumentError)
    end

    it "gets the resource" do
      subject.get(org, hook_id)
      expect(a_get(request_path)).to have_been_made
    end

    it "gets hook information" do
      hook = subject.get(org, hook_id)
      expect(hook.id).to eq(hook_id)
      expect(hook.name).to eq('web')
    end

    it "returns response wrapper" do
      hook = subject.get(org, hook_id)
      expect(hook).to be_a(Github::ResponseWrapper)
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get org, hook_id }
  end
end # get
