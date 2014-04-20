# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Releases, '#list' do
  let(:owner) { 'peter-murach' }
  let(:repo)  { 'github' }
  let(:path)  { "/repos/#{owner}/#{repo}/releases" }

  before {
    stub_get(path).to_return(body: body, status: status,
      headers: {content_type: 'application/json; charset=utf-8'})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body)   { fixture("repos/releases.json") }
    let(:status) { 200 }

    it { should respond_to :all }

    it { expect { subject.list }.to raise_error(ArgumentError) }

    it "should fail to get resource without repository" do
      expect { subject.list owner }.to raise_error(ArgumentError)
    end

    it "should get the resources" do
      subject.list owner, repo
      expect(a_get(path)).to have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list owner, repo }
    end

    it "should get key information" do
      keys = subject.list owner, repo
      expect(keys.first.tag_name).to eq 'v1.0.0'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list(owner, repo) { |obj| yielded << obj }
      expect(yielded).to eq result
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.list owner, repo }
  end
end # list
