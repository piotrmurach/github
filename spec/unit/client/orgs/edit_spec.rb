# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Orgs, '#edit' do
  let(:org)   { 'github' }
  let(:request_path) { "/orgs/#{org}" }
  let(:body) { fixture("orgs/org.json") }
  let(:status) { 200 }
  let(:inputs) {
    { :billing_email => 'support@github.com',
      :blog => "https://github.com/blog",
      :company => "GitHub",
      :email => "support@github.com",
      :location => "San Francisco",
      :name => "github"
    }
  }

  before do
    stub_patch(request_path).with(inputs).
      to_return(body: body, status: status,
      headers: {content_type: 'application/json; charset=utf-8'})
  end

  after { reset_authentication_for(subject) }

  context "resource edited successfully" do
    it "fails to edit without 'user/repo' parameters" do
      expect { subject.edit }.to raise_error(ArgumentError)
    end

    it "edits the resource" do
      subject.edit(org)
      expect(a_patch(request_path).with(inputs)).to have_been_made
    end

    it "returns resource" do
      organisation = subject.edit org
      expect(organisation).to be_a Github::ResponseWrapper
    end

    it "retrieves information" do
      organisation = subject.edit org
      expect(organisation.name).to eq('github')
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.edit org }
  end
end # edit
