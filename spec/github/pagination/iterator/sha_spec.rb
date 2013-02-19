# encoding: utf-8

require 'spec_helper'

describe Github::PageIterator, 'when sha' do
  let(:header) { {"Link" => "<https://api.github.com/repos/peter-murach/github/commits?last_sha=d1e503c02fa770859895dd0d12aedefa28b95723&per_page=30&sha=801d80dfd59bf1d2cb30a243799953ab683a3abd&top=801d80dfd59bf1d2cb30a243799953ab683a3abd>; rel=\"next\", <https://api.github.com/repos/peter-murach/github/commits?per_page=30&sha=801d80dfd59bf1d2cb30a243799953ab683a3abd>; rel=\"first\"" }
  }
  let(:links) { Github::PageLinks.new(header) }

  let(:first_link) { "https://api.github.com/repos/peter-murach/github/commits?per_page=30&sha=801d80dfd59bf1d2cb30a243799953ab683a3abd" }
  let(:next_link)  { "https://api.github.com/repos/peter-murach/github/commits?last_sha=d1e503c02fa770859895dd0d12aedefa28b95723&per_page=30&sha=801d80dfd59bf1d2cb30a243799953ab683a3abd&top=801d80dfd59bf1d2cb30a243799953ab683a3abd" }

  let(:top_sha)  { '801d80dfd59bf1d2cb30a243799953ab683a3abd' }
  let(:sha)      { '801d80dfd59bf1d2cb30a243799953ab683a3abd' }
  let(:last_sha) { "d1e503c02fa770859895dd0d12aedefa28b95723"}

  let(:current_api) { Github::Repos.new }
  let(:user)   { 'wycats' }
  let(:response) { stub(:response).as_null_object }

  subject(:instance) { described_class.new(links, current_api) }

  before {
    instance.stub(:has_next?).and_return true
    instance.stub(:next_page).and_return -1
    stub_get("/repos/peter-murach/github/commits").
      to_return(:body => '', :status => 200, :headers => header)
  }

  it { described_class::ATTRIBUTES.should_not be_nil }

  its(:first_page) { should eq -1 }

  its(:first_page_uri) { should eq first_link }

  its(:next_page) { should eq -1 }

  its(:next_page_uri) { should eq next_link}

  its(:prev_page) { should eq -1 }

  its(:prev_page_uri) { should be_nil }

  its(:last_page) { should eq -1 }

  its(:last_page_uri) { should be_nil }

  context 'first page request' do
    it 'performs request' do
      instance.should_receive(:page_request).
        with("/repos/peter-murach/github/commits",
          'sha' => 'master', 'per_page' => 30).and_return response
      instance.first
    end
  end

  context 'next page request' do
    it 'performs request' do
      instance.should_receive(:page_request).
        with("/repos/peter-murach/github/commits", 'last_sha' => last_sha,
          'sha' => last_sha, 'per_page' => 30, 'top' => top_sha).
        and_return response
      instance.next
    end
  end

end
