# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Gists::Comments, '#edit' do
  let(:gist_id) { 1 }
  let(:comment_id) { 1 }
  let(:request_path) { "/gists/#{gist_id}/comments/#{comment_id}" }
  let(:inputs) {
    { "body" =>"Just commenting for the sake of commenting",
      "unrelated" => true }
  }

  before {
    stub_patch(request_path).with(inputs).
      to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce edited" do
    let(:status) { 201 }
    let(:body) { fixture('gists/comment.json') }

    it "fails to edit resource if 'content' input is missing" do
      expect {
        subject.edit(gist_id)
      }.to raise_error(ArgumentError)
    end

    it "edits resource successfully" do
      subject.edit(gist_id, comment_id, inputs)
      expect(a_patch(request_path).with(inputs)).to have_been_made
    end

    it "returns the resource" do
      comment = subject.edit(gist_id, comment_id, inputs)
      expect(comment).to be_a(Github::ResponseWrapper)
    end

    it "gets the comment information" do
      comment = subject.edit(gist_id, comment_id, inputs)
      expect(comment.user.login).to eq('octocat')
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.edit gist_id, comment_id, inputs }
  end
end # edit
