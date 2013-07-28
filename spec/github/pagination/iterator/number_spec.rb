# encoding: utf-8

require 'spec_helper'

describe Github::PageIterator, 'when number' do
  let(:header) { {"Link" => "<https://api.github.com/users/wycats/repos?page=4&per_page=20>; rel=\"next\", <https://api.github.com/users/wycats/repos?page=6&per_page=20>; rel=\"last\", <https://api.github.com/users/wycats/repos?page=1&per_page=20>; rel=\"first\", <https://api.github.com/users/wycats/repos?page=2&per_page=20>; rel=\"prev\""}
  }
  let(:links) { Github::PageLinks.new(header) }

  let(:first_link) { "https://api.github.com/users/wycats/repos?page=1&per_page=20" }
  let(:next_link) { "https://api.github.com/users/wycats/repos?page=4&per_page=20" }
  let(:prev_link) { "https://api.github.com/users/wycats/repos?page=2&per_page=20" }
  let(:last_link) { "https://api.github.com/users/wycats/repos?page=6&per_page=20" }

  let(:current_api) { Github::Repos.new }
  let(:user)     { 'wycats' }
  let(:response) { double(:response).as_null_object }

  subject(:instance) { described_class.new(links, current_api) }

  before {
    instance.stub(:has_next?).and_return true
    stub_get("/users/#{user}/repos").
      with(:query => { 'page' => '4', 'per_page' => '20'}).
      to_return(:body => '', :status => 200, :headers => header)
  }

  it { described_class::ATTRIBUTES.should_not be_nil }

  its(:first_page) { should eq 1 }

  its(:first_page_uri) { should eq first_link }

  its(:next_page) { should eq 4 }

  its(:next_page_uri) { should eq next_link}

  its(:prev_page) { should eq 2 }

  its(:prev_page_uri) { should eq prev_link }

  its(:last_page) { should eq 6 }

  its(:last_page_uri) { should eq last_link }

  context 'has_next?' do
    it "return true when next_page_uri is present" do
      expect(instance.has_next?).to be_true
    end
  end

  context 'first page request' do
    it 'returns nil if there are no more pages' do
      instance.stub(:first_page_uri).and_return false
      expect(instance.first).to be_nil
    end

    it 'performs request' do
      instance.should_receive(:page_request).
        with("/users/#{user}/repos", 'per_page' => 20, 'page' => 1).
        and_return response
      instance.first
    end
  end

  context 'next page request' do
    it 'returns nil if there are no more pages' do
      instance.stub(:has_next?).and_return false
      expect(instance.next).to be_nil
    end

    it 'performs request' do
      instance.should_receive(:page_request).with("/users/#{user}/repos",
          'page' => 4,'per_page' => 20).and_return response
      instance.next
    end
  end

  context 'prev page request' do
    it 'returns nil if there are no more pages' do
      instance.stub(:prev_page_uri).and_return false
      expect(instance.prev).to be_nil
    end

    it 'performs request' do
      instance.should_receive(:page_request).with("/users/#{user}/repos",
          'page' => 2,'per_page' => 20).and_return response
      instance.prev
    end
  end

  context 'last page request' do
    it 'returns nil if there are no more pages' do
      instance.stub(:last_page_uri).and_return false
      expect(instance.last).to be_nil
    end

    it 'performs request' do
      instance.should_receive(:page_request).with("/users/#{user}/repos",
          'page' => 6,'per_page' => 20).and_return response
      instance.last
    end
  end

  context 'get_page request' do
    it 'returns nil if there are no more pages' do
      instance.stub(:first_page_uri).and_return nil
      instance.stub(:last_page_uri).and_return nil
      expect(instance.get_page(5)).to be_nil
    end

    it 'performs request' do
      instance.should_receive(:page_request).with("/users/#{user}/repos",
          'page' => 2,'per_page' => 20).and_return response
      instance.get_page(2)
    end
  end
end
