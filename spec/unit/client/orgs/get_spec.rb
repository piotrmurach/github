# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Orgs, '#get' do
  let(:org)   { 'github' }
  let(:request_path) {  "/orgs/#{org}" }
  let(:body) { fixture('orgs/org.json') }
  let(:status) { 200 }

  before do
    stub_get(request_path).to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  end

  after { reset_authentication_for(subject) }

  context "resource found" do
    it "fails to get resource without org name" do
      expect { subject.get }.to raise_error(ArgumentError)
    end

    it "gets the resource" do
      subject.get(org)
      expect(a_get(request_path)).to have_been_made
    end

    it "gets org information" do
      organisation = subject.get org
      expect(organisation.id).to eq(1)
      expect(organisation.login).to eq('github')
    end

    it "returns response wrapper" do
      organisation = subject.get org
      expect(organisation).to be_a Github::ResponseWrapper
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get org }
  end
end # get
