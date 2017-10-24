# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Orgs::Hooks, '#delete' do
  let(:org_name) { 'API-sampler' }
  let(:hook_id) { 1 }
  let(:request_path) { "/orgs/#{org_name}/hooks/#{hook_id}" }

  before {
    stub_delete(request_path).to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource removed successfully" do
    let(:body) { '' }
    let(:status) { 204 }

    it "fails to delete without 'org' parameter" do
      expect { subject.delete }.to raise_error(ArgumentError)
    end

    it "fails to delete resource without 'hook_id'" do
      expect { subject.delete(org_name) }.to raise_error(ArgumentError)
    end

    it "deletes the resource" do
      subject.delete(org_name, hook_id)
      expect(a_delete(request_path)).to have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.delete org_name, hook_id }
  end
end # delete
