# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Gists::Comments, '#delete' do
  let(:gist_id)   { 1 }
  let(:comment_id) { 1 }
  let(:request_path) { "/gists/#{gist_id}/comments/#{comment_id}" }
  let(:body) { '' }
  let(:status) { 204 }

  before {
    stub_delete(request_path).to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  it "fails to delete resource if id is missing" do
    expect { subject.delete gist_id, nil }.to raise_error(ArgumentError)
  end

  it "should create resource successfully" do
    subject.delete(gist_id, comment_id)
    expect(a_delete(request_path)).to have_been_made
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.delete gist_id, comment_id }
  end
end # delete
