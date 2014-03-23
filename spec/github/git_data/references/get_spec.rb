# encoding: utf-8

require 'spec_helper'

describe Github::Client::GitData::References, '#get' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:ref) { "heads/master" }
  let(:request_path) { "/repos/#{user}/#{repo}/git/refs/#{ref}" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body) { fixture('git_data/reference.json') }
    let(:status) { 200 }

    it { should respond_to :find }

    it "should fail to get resource without ref" do
      expect { subject.get user, repo, nil }.to raise_error(ArgumentError)
    end

    context 'when wrong ref' do
      let(:ref) { 'branch' }

      it "should fail to get resource with wrong ref" do
        expect { subject.get user, repo, '/branch' }.not_to raise_error()
      end
    end

    it "should get the resource" do
      subject.get user, repo, ref
      a_get(request_path).should have_been_made
    end

    it "should get reference information" do
      reference = subject.get user, repo, ref
      reference.first.ref.should eql "refs/heads/sc/featureA"
    end

    it "should return mash" do
      reference = subject.get user, repo, ref
      reference.first.should be_a Hashie::Mash
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get user, repo, ref }
  end

end # get
