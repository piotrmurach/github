# encoding: utf-8

require 'spec_helper'

describe Github::Client::Gists, '#delete' do
  let(:gist_id)   { 1 }
  let(:request_path) { "/gists/#{gist_id}" }
  let(:body) { fixture('gists/gist.json') }
  let(:status) { 204 }

  before {
    stub_delete(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  it 'should raise error if gist id not present' do
    expect { subject.delete }.to raise_error(ArgumentError)
  end

  it "should remove resource successfully" do
    subject.delete gist_id
    a_delete(request_path).should have_been_made
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.delete gist_id }
  end

end # delete
