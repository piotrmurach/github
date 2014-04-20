# encoding: utf-8

require 'spec_helper'

describe Github::Client::Gists::Comments, '#get' do
  let(:gist_id) { 1 }
  let(:comment_id) { 1 }
  let(:request_path) { "/gists/#{gist_id}/comments/#{comment_id}" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context 'resource found' do
    let(:body) { fixture('gists/comment.json') }
    let(:status) { 200 }

    it { should respond_to :find }

    it "should fail to get resource without comment id" do
      expect { subject.get nil, nil }.to raise_error(ArgumentError)
    end

    it "should get the resource" do
      subject.get gist_id, comment_id
      a_get(request_path).should have_been_made
    end

    it "should get comment information" do
      comment = subject.get gist_id, comment_id
      comment.id.should eq comment_id
      comment.user.login.should == 'octocat'
    end

    it "should return mash" do
      comment = subject.get gist_id, comment_id
      comment.should be_a Github::ResponseWrapper
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get gist_id, comment_id }
  end

end # get
