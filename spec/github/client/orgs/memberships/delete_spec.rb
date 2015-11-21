# encoding: utf-8

require 'spec_helper'

describe Github::Client::Orgs::Memberships, '#delete' do
  let(:request_path) { "/orgs/rails/memberships/piotr" }

  before {
    stub_delete(request_path).to_return(body: body, status: status,
      headers: {content_type: 'application/json; charset=utf-8'})
  }

  after { reset_authentication_for(subject) }

  context "resource deleted successfully" do
    let(:body) { '' }
    let(:status) { 204 }

    it "fails to delete without 'username' parameter" do
      expect { subject.delete 'rails' }.to raise_error(ArgumentError)
    end

    it "deletes the resource" do
      subject.delete('rails', 'piotr')
      expect(a_delete(request_path)).to have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.delete('rails', 'piotr') }
  end
end # delete
