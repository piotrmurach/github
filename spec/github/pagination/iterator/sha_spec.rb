# encoding: utf-8

require 'spec_helper'

describe Github::PageIterator, 'when sha' do
  let(:header) { {"Link" => "<https://api.github.com/repos/peter-murach/github/commits?last_sha=d1e503c02fa770859895dd0d12aedefa28b95723&per_page=30&sha=801d80dfd59bf1d2cb30a243799953ab683a3abd&top=801d80dfd59bf1d2cb30a243799953ab683a3abd>; rel=\"next\", <https://api.github.com/repos/peter-murach/github/commits?per_page=30&sha=801d80dfd59bf1d2cb30a243799953ab683a3abd>; rel=\"first\"" }
  }

  let(:first_link) { "https://api.github.com/repos/peter-murach/github/commits?per_page=30&sha=801d80dfd59bf1d2cb30a243799953ab683a3abd" }
  let(:next_link)  { "https://api.github.com/repos/peter-murach/github/commits?last_sha=d1e503c02fa770859895dd0d12aedefa28b95723&per_page=30&sha=801d80dfd59bf1d2cb30a243799953ab683a3abd&top=801d80dfd59bf1d2cb30a243799953ab683a3abd" }

  let(:top_sha)  { '801d80dfd59bf1d2cb30a243799953ab683a3abd' }
  let(:sha)      { '801d80dfd59bf1d2cb30a243799953ab683a3abd' }
  let(:last_sha) { "d1e503c02fa770859895dd0d12aedefa28b95723"}

  let(:links)       { Github::PageLinks.new(header) }
  let(:current_api) { Github::Client::Repos.new }
  let(:user)     { 'wycats' }
  let(:response) { double(:response).as_null_object }

  subject(:iterator) { described_class.new(links, current_api) }

  before {
    allow(iterator).to receive(:next?).and_return(true)
    allow(iterator).to receive(:next_page).and_return(-1)
    stub_get("/repos/peter-murach/github/commits").
      to_return(body: '', status: 200, headers: header)
  }

  it { expect(described_class::ATTRIBUTES).to_not be_nil }

  it { expect(iterator.first_page).to eq(-1) }

  it { expect(iterator.first_page_uri).to eq(first_link) }

  it { expect(iterator.next_page).to eq(-1) }

  it { expect(iterator.next_page_uri).to eq(next_link) }

  it { expect(iterator.prev_page).to eq(-1) }

  it { expect(iterator.prev_page_uri).to be_nil }

  it { expect(iterator.last_page).to eq(-1) }

  it { expect(iterator.last_page_uri).to be_nil }

  context 'first page request' do
    it 'performs request' do
      expect(iterator).to receive(:page_request).
        with("/repos/peter-murach/github/commits",
          'sha' => 'master', 'per_page' => 30).and_return(response)
      iterator.first
    end
  end

  context 'next page request' do
    it 'performs request' do
      expect(iterator).to receive(:page_request).
        with("/repos/peter-murach/github/commits", 'last_sha' => last_sha,
          'sha' => last_sha, 'per_page' => 30, 'top' => top_sha).
        and_return(response)
      iterator.next
    end
  end
end
