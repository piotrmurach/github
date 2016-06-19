# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Orgs::Members, '#delete' do
  let(:org)    { 'github' }
  let(:member) { 'peter-murach' }
  let(:request_path) { "/orgs/#{org}/members/#{member}" }

  before do
    stub_delete(request_path).to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  end

  context "resource deleted successfully" do
    let(:body)  { '' }
    let(:status) { 204 }

    it "fails to delete without org and member parameters" do
      expect { subject.delete }.to raise_error(ArgumentError)
    end

    it { expect { subject.delete org }.to raise_error(ArgumentError) }

    it "deletes the resource" do
      subject.delete(org, member)
      expect(a_delete(request_path)).to have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.delete org, member }
  end
end # delete
