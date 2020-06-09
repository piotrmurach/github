# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Gists::Comments, '#get' do
  let(:gist_id) { 1 }
  let(:comment_id) { 1 }
  let(:request_path) { "/gists/#{gist_id}/comments/#{comment_id}" }

  before {
    stub_get(request_path).to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context 'resource found' do
    let(:body) { fixture('gists/comment.json') }
    let(:status) { 200 }

    it { is_expected.to respond_to :find }

    it "fails to get resource without comment id" do
      expect { subject.get nil, nil }.to raise_error(ArgumentError)
    end

    it "gets the resource" do
      subject.get gist_id, comment_id
      expect(a_get(request_path)).to have_been_made
    end

    it "gets comment information" do
      comment = subject.get gist_id, comment_id
      expect(comment.id).to eq comment_id
      expect(comment.user.login).to eq('octocat')
    end

    it "returns response wrapper" do
      comment = subject.get gist_id, comment_id
      expect(comment).to be_a Github::ResponseWrapper
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get gist_id, comment_id }
  end
end # get
