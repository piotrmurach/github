# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Orgs::Hooks, '#edit' do
  let(:org) { 'API-sampler' }
  let(:hook_id) { 1 }
  let(:request_path) {"/orgs/#{org}/hooks/#{hook_id}" }
  let(:inputs) {
    {
      :name => 'web',
      :config => {
        :url => "http://something.com/webhook",
        :content_type => "json"
      },
      :active => true
    }
  }

  before do
    stub_patch(request_path).with(body: inputs.except(:unrelated)).
      to_return(body: body, status: status,
        headers: {content_type: "application/json; charset=utf-8"})
  end

  after { reset_authentication_for(subject) }

  context "resource edited successfully" do
    let(:body) { fixture("orgs/hook.json") }
    let(:status) { 200 }

    it "fails to edit without 'org' parameter" do
      expect { subject.edit }.to raise_error(ArgumentError)
    end

    it "fails to edit resource without 'name' parameter" do
      expect{
        subject.edit(org, hook_id, inputs.except(:name))
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "fails to edit resource without 'hook_id'" do
      expect { subject.edit org }.to raise_error(ArgumentError)
    end

    it "fails to edit resource without 'config' parameter" do
      expect {
        subject.edit(org, hook_id, inputs.except(:config))
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "edits the resource" do
      subject.edit org, hook_id, inputs
      expect(a_patch(request_path).with(body: inputs)).to have_been_made
    end

    it "returns resource" do
      hook = subject.edit(org, hook_id, inputs)
      expect(hook).to be_a(Github::ResponseWrapper)
    end

    it "retrieve information" do
      hook = subject.edit(org, hook_id, inputs)
      expect(hook.name).to eq('web')
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.edit org, hook_id, inputs }
  end
end # edit
