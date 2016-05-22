# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::PullRequests::Comments, '#edit' do
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/pulls/comments/#{number}" }
  let(:number) { 1 }
  let(:inputs) {
    {
      "body" => "Nice change",
      'unrelated' => 'giberrish'
    }
  }

  before {
    stub_patch(request_path).with(inputs.except('unrelated')).
      to_return(body: body, status: status,
                headers: {content_type: "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce edited" do
    let(:body) { fixture('pull_requests/comment.json') }
    let(:status) { 200 }

    it { expect { subject.edit }.to raise_error(ArgumentError) }

    it "edits resource successfully" do
      subject.edit(user, repo, number, inputs)
      expect(a_patch(request_path).with(inputs)).to have_been_made
    end

    it "returns the resource" do
      comment = subject.edit(user, repo, number, inputs)
      expect(comment).to be_a(Github::ResponseWrapper)
    end

    it "should get the comment information" do
      comment = subject.edit(user, repo, number, inputs)
      expect(comment.user.login).to eq('octocat')
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.edit(user, repo, number, inputs) }
  end
end # edit
