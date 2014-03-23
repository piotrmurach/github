# encoding: utf-8

require 'spec_helper'

describe Github::Client::Gists::Comments, '#list' do
  let(:gist_id) { 1 }
  let(:request_path) { "/gists/#{gist_id}/comments" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context 'resource found' do
    let(:body) { fixture('gists/comments.json') }
    let(:status) { 200 }

    it { should respond_to :all }

    it "throws error if gist id not provided" do
      expect { subject.list }.to raise_error(ArgumentError)
    end

    it "should get the resources" do
      subject.list gist_id
      a_get(request_path).should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list gist_id }
    end

    it "should get gist information" do
      comments = subject.list gist_id
      comments.first.user.login.should == 'octocat'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list(gist_id) { |obj| yielded << obj }
      yielded.should == result
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list gist_id }
    end
  end

end # list
