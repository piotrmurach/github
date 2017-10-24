# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Orgs::Hooks, '#create' do
  let(:org) { 'API-sampler' }
  let(:request_path) { "/orgs/#{org}/hooks" }
  let(:inputs) {
    {
      'name' => 'web',
      'config' => {
        'url' => "http://something.com/webhook",
        'content_type' => "json"
      },
      'active' => true
    }
  }

  before {
    stub_post(request_path).with(body: inputs.except('unrelated')).
      to_return(body: body, status: status,
        headers: {content_type: "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce created" do
    let(:body) { fixture('orgs/hook.json') }
    let(:status) { 201 }

    it "fails to create resource if 'name' input is missing" do
      expect {
        subject.create(org, inputs.except('name'))
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "fails to create resource if 'config' input is missing" do
      expect {
        subject.create(org, inputs.except('config'))
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "creates resource successfully" do
      subject.create org, inputs
      expect(a_post(request_path).with(body: inputs)).to have_been_made
    end

    it "returns the resource" do
      hook = subject.create(org, inputs)
      expect(hook).to be_a(Github::ResponseWrapper)
    end

    it "gets the hook information" do
      hook = subject.create org, inputs
      expect(hook.name).to eq('web')
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create org, inputs }
  end
end # create
