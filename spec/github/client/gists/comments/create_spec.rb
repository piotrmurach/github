# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Gists::Comments, '#create' do
  let(:gist_id) { 1 }
  let(:request_path) { "/gists/#{gist_id}/comments" }
  let(:inputs) {
    { "body" =>"Just commenting for the sake of commenting",
      "unrelated" => true }
  }

  before {
    stub_post(request_path).with(body: inputs).
      to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce created" do
    let(:body) { fixture('gists/comment.json') }
    let(:status) { 201 }

    it "fails to create resource if 'content' input is missing" do
      expect {
        subject.create
      }.to raise_error(ArgumentError)
    end

    it "creates resource successfully" do
      subject.create gist_id, inputs
      expect(a_post(request_path).with(body: inputs)).to have_been_made
    end

    it "returns the resource" do
      comment = subject.create gist_id, inputs
      expect(comment).to be_a Github::ResponseWrapper
    end

    it "gets the comment information" do
      comment = subject.create gist_id, inputs
      expect(comment.user.login).to eq('octocat')
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create gist_id, inputs }
  end
end # create
