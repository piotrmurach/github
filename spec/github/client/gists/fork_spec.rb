# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Gists, '#fork' do
  let(:gist_id) { 1 }
  let(:request_path) { "/gists/#{gist_id}/forks" }
  let(:body) { fixture('gists/gist.json') }
  let(:status) { 201 }

  before {
    stub_post(request_path).to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  it "fails to fork gist without gist id" do
    expect { subject.fork }.to raise_error(ArgumentError)
  end

  it "should fork resource successfully" do
    subject.fork(gist_id)
    expect(a_post(request_path)).to have_been_made
  end

  it "returns the resource" do
    gist = subject.fork(gist_id)
    expect(gist).to be_a(Github::ResponseWrapper)
  end

  it "gets the gist information" do
    gist = subject.fork gist_id
    expect(gist.user.login).to eq('octocat')
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.fork gist_id }
  end
end # fork
