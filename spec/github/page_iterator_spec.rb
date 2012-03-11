# encoding: utf-8

require 'spec_helper'

describe Github::PageIterator do
  let(:link) {
    "<https://api.github.com/users/wycats/repos?page=4&per_page=20>; rel=\"next\", <https://api.github.com/users/wycats/repos?page=6&per_page=20>; rel=\"last\", <https://api.github.com/users/wycats/repos?page=1&per_page=20>; rel=\"first\", <https://api.github.com/users/wycats/repos?page=2&per_page=20>; rel=\"prev\""
  }
  let(:sha_link) {
    "<https://api.github.com/repos/peter-murach/github/commits?last_sha=d1e503c02fa770859895dd0d12aedefa28b95723&per_page=30&sha=801d80dfd59bf1d2cb30a243799953ab683a3abd&top=801d80dfd59bf1d2cb30a243799953ab683a3abd>; rel=\"next\", <https://api.github.com/repos/peter-murach/github/commits?per_page=30&sha=801d80dfd59bf1d2cb30a243799953ab683a3abd>; rel=\"first\""
  }
  let(:env)      { { :response_headers => {'Link' => link } } }
  let(:sha_env)  { { :response_headers => {'Link' => sha_link } } }
  let(:first)  { "https://api.github.com/users/wycats/repos?page=1&per_page=20" }
  let(:nexxt)  { "https://api.github.com/users/wycats/repos?page=4&per_page=20" }
  let(:prev)   { "https://api.github.com/users/wycats/repos?page=2&per_page=20" }
  let(:last)   { "https://api.github.com/users/wycats/repos?page=6&per_page=20" }
  let(:user)   { 'wycats' }
  let(:last_sha) { "d1e503c02fa770859895dd0d12aedefa28b95723"}

  let(:instance) { Github::PageIterator.new(env) }
  let(:sha_instance) { Github::PageIterator.new(sha_env) }
  let(:sha_links) { Github::PageLinks.new(sha_env)}
  let(:sha_first) { "https://api.github.com/repos/peter-murach/github/commits?per_page=30&sha=801d80dfd59bf1d2cb30a243799953ab683a3abd" }
  let(:sha_next) { "https://api.github.com/repos/peter-murach/github/commits?last_sha=d1e503c02fa770859895dd0d12aedefa28b95723&per_page=30&sha=801d80dfd59bf1d2cb30a243799953ab683a3abd&top=801d80dfd59bf1d2cb30a243799953ab683a3abd"}

  it { described_class::ATTRIBUTES.should_not be_nil }

  context 'initialization' do

    it { instance.first_page.should eq 1 }
    it { instance.first_page_uri.should eq first }
    it { instance.next_page.should eq 4 }
    it { instance.next_page_uri.should eq nexxt }
    it { instance.prev_page.should eq 2 }
    it { instance.prev_page_uri.should eq prev }
    it { instance.last_page.should eql 6 }
    it { instance.last_page_uri.should eq last }

    it { sha_instance.first_page.should eq -1 }
    it { sha_instance.first_page_uri.should eq sha_first }
    it { sha_instance.next_page.should  eq -1 }
    it { sha_instance.next_page_uri.should  eq sha_next }
    it { sha_instance.prev_page.should eq -1 }
    it { sha_instance.prev_page_uri.should be_nil }
    it { sha_instance.last_page.should eql -1 }
    it { sha_instance.last_page_uri.should be_nil }

  end

  context 'has_next?' do
    it "return true when next_page_uri is present" do
      instance.has_next?.should be_true
    end

    it "returns false when next_page_uri is nil" do
      instance.should_receive(:next_page_uri).and_return nil
      instance.has_next?.should be_false
    end
  end

  context 'first' do
    before do
      Github.new
      instance.stub(:has_next?).and_return true
      stub_get("/users/#{user}/repos").
        with(:query => { 'per_page' => '20'}).
        to_return(:body => '', :status => 200,
          :headers => {
            :content_type => "application/json; charset=utf-8",
            'Link' => link
            }
        )
    end

    it 'returns nil if there are no more pages' do
      instance.stub(:first_page_uri).and_return false
      instance.first.should be_nil
    end

    it 'performs request' do
      link.stub(:links).and_return link
      instance.stub(:update_page_links)
      instance.should_receive(:page_request).
        with("https://api.github.com/users/#{user}/repos", 'per_page' => 20).
          and_return link
      instance.first
    end

    context 'no pagination params' do
      before do
        Github.new
        sha_instance.stub(:has_next?).and_return true
        sha_instance.stub(:next_page).and_return -1

        stub_get("/repos/peter-murach/github/commits").
          to_return(:body => '', :status => 200,
            :headers => {
              :content_type => "application/json; charset=utf-8",
              'Link' => sha_link
              }
          )
      end

      it 'receives sha params' do
        sha_link.stub(:links).and_return sha_links
        sha_instance.stub(:udpate_page_links)
        sha_instance.should_receive(:page_request).
          with("https://api.github.com/repos/peter-murach/github/commits",
            'sha' => 'master', 'per_page' => 30).and_return sha_link
        sha_instance.first
      end
    end
  end # first

  context 'next' do
    before do
      Github.new
      instance.stub(:has_next?).and_return true
      stub_get("/users/#{user}/repos").
        with(:query => { 'page' => '4', 'per_page' => '20'}).
        to_return(:body => '', :status => 200,
          :headers => {
            :content_type => "application/json; charset=utf-8",
            'Link' => link
            }
        )
    end

    it 'returns nil if there are no more pages' do
      instance.stub(:has_next?).and_return false
      instance.next.should be_nil
    end

    it 'performs request' do
      link.stub(:links).and_return link
      instance.stub(:update_page_links)
      instance.should_receive(:page_request).
        with("https://api.github.com/users/#{user}/repos",
          'page' => 4,'per_page' => 20).and_return link
      instance.next
    end

    context 'no pagination params' do
      before do
        Github.new
        sha_instance.stub(:has_next?).and_return true
        sha_instance.stub(:next_page).and_return -1

        stub_get("/repos/peter-murach/github/commits").
          to_return(:body => '', :status => 200,
            :headers => {
              :content_type => "application/json; charset=utf-8",
              'Link' => sha_link
              }
          )
      end

      it 'receives sha params' do
        sha_link.stub(:links).and_return sha_links
        sha_instance.stub(:udpate_page_links)
        sha_instance.should_receive(:page_request).
          with("https://api.github.com/repos/peter-murach/github/commits",
            'sha' => last_sha, 'per_page' => 30).and_return sha_link
        sha_instance.next
      end
    end
  end # next

  context 'prev' do
    before do
      Github.new
      instance.stub(:has_next?).and_return true
      stub_get("/users/#{user}/repos").
        with(:query => { 'page' => '2', 'per_page' => '20'}).
        to_return(:body => '', :status => 200,
          :headers => {
            :content_type => "application/json; charset=utf-8",
            'Link' => link
            }
        )
    end

    it 'returns nil if there are no previous pages' do
      instance.stub(:prev_page_uri).and_return false
      instance.prev.should be_nil
    end

    it 'performs request' do
      link.stub(:links).and_return link
      instance.stub(:update_page_links)
      instance.should_receive(:page_request).
        with("https://api.github.com/users/#{user}/repos",
          'page' => 2,'per_page' => 20).and_return link
      instance.prev
    end
  end # prev

  context 'last' do
    before do
      Github.new
      instance.stub(:has_next?).and_return true
      stub_get("/users/#{user}/repos").
        with(:query => { 'page' => '6', 'per_page' => '20'}).
        to_return(:body => '', :status => 200,
          :headers => {
            :content_type => "application/json; charset=utf-8",
            'Link' => link
            }
        )
    end

    it 'returns nil if there is not last page' do
      instance.stub(:last_page_uri).and_return false
      instance.last.should be_nil
    end

    it 'performs request' do
      link.stub(:links).and_return link
      instance.stub(:update_page_links)
      instance.should_receive(:page_request).
        with("https://api.github.com/users/#{user}/repos",
          'page' => 6,'per_page' => 20).and_return link
      instance.last
    end
  end # last

  context 'get_page' do
    before do
      Github.new
      instance.stub(:has_next?).and_return true
      stub_get("/users/#{user}/repos").
        with(:query => { 'page' => '6', 'per_page' => '20'}).
        to_return(:body => '', :status => 200,
          :headers => {
            :content_type => "application/json; charset=utf-8",
            'Link' => link
            }
        )
    end

    it 'returns nil if there are no pages' do
      instance.stub(:first_page_uri).and_return nil
      instance.stub(:last_page_uri).and_return nil
      instance.get_page(5).should be_nil
    end

    it 'finds a single page' do
      instance.should_receive(:update_page_links)
      instance.should_receive(:page_request).
        with("https://api.github.com/users/#{user}/repos",
          'page' => 2, 'per_page' => 20).and_return link
      link.stub(:links).and_return link
      instance.get_page(2)
    end
  end # get_page

end # Github::PageIterator
