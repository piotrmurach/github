# encoding: utf-8

require 'spec_helper'

describe Github::PageIterator, 'when number' do
  let(:header) { {
    "Link" => "<https://api.github.com/users/wycats/repos?page=4&per_page=20>; rel=\"next\", <https://api.github.com/users/wycats/repos?page=6&per_page=20>; rel=\"last\", <https://api.github.com/users/wycats/repos?page=1&per_page=20>; rel=\"first\", <https://api.github.com/users/wycats/repos?page=2&per_page=20>; rel=\"prev\""
  } }

  let(:first_link) { "https://api.github.com/users/wycats/repos?page=1&per_page=20" }
  let(:next_link) { "https://api.github.com/users/wycats/repos?page=4&per_page=20" }
  let(:prev_link) { "https://api.github.com/users/wycats/repos?page=2&per_page=20" }
  let(:last_link) { "https://api.github.com/users/wycats/repos?page=6&per_page=20" }

  let(:links)       { Github::PageLinks.new(header) }
  let(:current_api) { Github::Client::Repos.new }
  let(:user)        { 'wycats' }
  let(:response)    { double(:response).as_null_object }

  subject(:iterator) { described_class.new(links, current_api) }

  before {
    allow(iterator).to receive(:next?).and_return(true)
    stub_get("/users/#{user}/repos").
      with(query: { 'page' => '4', 'per_page' => '20'}).
      to_return(:body => '', :status => 200, :headers => header)
  }

  it { described_class::ATTRIBUTES.should_not be_nil }

  it { expect(iterator.first_page).to eq(1) }

  it { expect(iterator.first_page_uri).to eq(first_link) }

  it { expect(iterator.next_page).to eq(4)}

  it { expect(iterator.next_page_uri).to eq(next_link) }

  it { expect(iterator.prev_page).to eq(2)}

  it { expect(iterator.prev_page_uri).to eq(prev_link) }

  it { expect(iterator.last_page).to eq(6)}

  it { expect(iterator.last_page_uri).to eq(last_link) }

  context 'next?' do
    it "returns true when next_page_uri is present" do
      expect(iterator.next?).to eq(true)
    end
  end

  context 'first page request' do
    it 'returns nil if there are no more pages' do
      allow(iterator).to receive(:first_page_uri).and_return(false)
      expect(iterator.first).to be_nil
    end

    it 'performs request' do
      expect(iterator).to receive(:page_request).
        with("/users/#{user}/repos", 'per_page' => 20, 'page' => 1).
        and_return(response)
      iterator.first
    end
  end

  context 'next page request' do
    it 'returns nil if there are no more pages' do
      allow(iterator).to receive(:next?).and_return(false)
      expect(iterator.next).to be_nil
    end

    it 'performs request' do
      expect(iterator).to receive(:page_request).
        with("/users/#{user}/repos", 'page' => 4,'per_page' => 20).
        and_return(response)
      iterator.next
    end
  end

  context 'prev page request' do
    it 'returns nil if there are no more pages' do
      allow(iterator).to receive(:prev_page_uri).and_return(false)
      expect(iterator.prev).to be_nil
    end

    it 'performs request' do
      expect(iterator).to receive(:page_request).
        with("/users/#{user}/repos", 'page' => 2,'per_page' => 20).
        and_return(response)
      iterator.prev
    end
  end

  context 'last page request' do
    it 'returns nil if there are no more pages' do
      allow(iterator).to receive(:last_page_uri).and_return(false)
      expect(iterator.last).to be_nil
    end

    it 'performs request' do
      expect(iterator).to receive(:page_request).
        with("/users/#{user}/repos", 'page' => 6,'per_page' => 20).
        and_return(response)
      iterator.last
    end
  end

  context 'get_page request' do
    it 'returns nil if there are no more pages' do
      allow(iterator).to receive(:first_page_uri).and_return(nil)
      allow(iterator).to receive(:last_page_uri).and_return(nil)
      expect(iterator.get_page(5)).to be_nil
    end

    it 'performs request' do
      expect(iterator).to receive(:page_request).
        with("/users/#{user}/repos", 'page' => 2,'per_page' => 20).
        and_return(response)
      iterator.get_page(2)
    end
  end
end
