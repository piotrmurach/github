# encoding: utf-8

require 'spec_helper'

describe Github::Client::Gists, '#unstar' do
  let(:gist_id) { 1 }
  let(:request_path) { "/gists/#{gist_id}/star" }
  let(:body) { '' }
  let(:status) { 204 }

  before {
    stub_delete(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  it "should raise error if gist id not present" do
    expect { subject.unstar }.to raise_error(ArgumentError)
  end

  it 'successfully stars a gist' do
    subject.unstar gist_id
    a_delete(request_path).should have_been_made
  end

  it "should return 204 with a message 'Not Found'" do
    subject.unstar(gist_id).status.should be 204
  end
end # unstar
