# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Gists, '#unstar' do
  let(:gist_id) { 1 }
  let(:request_path) { "/gists/#{gist_id}/star" }
  let(:body) { '' }
  let(:status) { 204 }

  before {
    stub_delete(request_path).to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  it "raises error if gist id not present" do
    expect { subject.unstar }.to raise_error(ArgumentError)
  end

  it 'successfully stars a gist' do
    subject.unstar(gist_id)
    expect(a_delete(request_path)).to have_been_made
  end

  it "returns 204 with a message 'Not Found'" do
    expect(subject.unstar(gist_id).status).to be 204
  end
end # unstar
