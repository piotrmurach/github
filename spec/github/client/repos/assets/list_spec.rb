# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Releases::Assets, '#list' do
  let(:owner) { 'peter-murach' }
  let(:repo)  { 'github' }
  let(:id)    { 1 }
  let(:path)  { "/repos/#{owner}/#{repo}/releases/#{id}/assets" }

  before {
    stub_get(path).to_return(body: body, status: status,
      headers: {content_type: 'application/json; charset=utf-8'})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body)   { fixture("repos/assets.json") }
    let(:status) { 200 }

    it { should respond_to :all }

    it { expect { subject.list }.to raise_error(ArgumentError) }

    it "should fail to get resource without repository" do
      expect { subject.list owner }.to raise_error(ArgumentError)
    end

    it "should get the resources" do
      subject.list owner, repo, id
      expect(a_get(path)).to have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list owner, repo, id }
    end

    it "should get asset information" do
      assets = subject.list owner, repo, id
      expect(assets.first.name).to eq 'example.zip'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list(owner, repo, id) { |obj| yielded << obj }
      expect(yielded).to eq result
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.list owner, repo, id }
  end
end # list
