# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos, '#get_by_id' do
  let(:repo_id) { 1296269 }
  let(:request_path) { "/repositories/#{repo_id}" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  context "resource found" do
    let(:body)   { fixture('repos/repo.json') }
    let(:status) { 200 }

    it { is_expected.to respond_to(:find_by_id) }

    it "should raise error when no parameters" do
      expect { subject.get_by_id }.to raise_error(ArgumentError)
    end

    it "should find resources" do
      subject.get_by_id repo_id
      expect(a_get(request_path)).to have_been_made
    end

    it "should return repository mash" do
      repository = subject.get_by_id repo_id
      expect(repository).to be_a Github::ResponseWrapper
    end

    it "should get repository information" do
      repository = subject.get_by_id repo_id
      expect(repository.name).to eq 'Hello-World'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get_by_id repo_id }
  end
end # get_by_id
