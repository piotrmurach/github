# frozen_string_literal: true
# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Projects, '#delete' do
  let(:project_id)   { 1002604 }
  let(:request_path) { "/projects/#{project_id}" }
  let(:body) { '' }
  let(:status) { 204 }

  before {
    stub_delete(request_path).to_return(body: body, status: status,
      headers: { content_type: "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  it { expect(subject).to respond_to :remove }

  it "deletes the resource successfully" do
    subject.delete project_id
    expect(a_delete(request_path)).to have_been_made
  end

  it "fails to delete resource without 'id' parameter" do
    expect { subject.delete }.to raise_error(ArgumentError)
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.delete project_id }
  end
end # delete
