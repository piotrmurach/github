# encoding: utf-8

require 'spec_helper'

describe Github::PageLinks do
  let(:link) {
    "<https://api.github.com/users/wycats/repos?page=4&per_page=20>; rel=\"next\", <https://api.github.com/users/wycats/repos?page=6&per_page=20>; rel=\"last\", <https://api.github.com/users/wycats/repos?page=1&per_page=20>; rel=\"first\", <https://api.github.com/users/wycats/repos?page=2&per_page=20>; rel=\"prev\""
  }
  let(:response_headers)  { { 'Link' => link } }

  let(:first) { "https://api.github.com/users/wycats/repos?page=1&per_page=20" }
  let(:last)  { "https://api.github.com/users/wycats/repos?page=6&per_page=20" }
  let(:prev)  { "https://api.github.com/users/wycats/repos?page=2&per_page=20" }
  let(:nexxt)  { "https://api.github.com/users/wycats/repos?page=4&per_page=20" }

  context 'build page links instance' do

    it 'parses first link successfully' do
      Github::PageLinks.new(response_headers).first.should eql first
    end

    it 'parses last link successfully' do
      Github::PageLinks.new(response_headers).last.should eql last
    end

    it 'parses next link successfully' do
      Github::PageLinks.new(response_headers).next.should eql nexxt
    end

    it 'parses prev link successfully' do
      Github::PageLinks.new(response_headers).prev.should eql prev
    end
  end

end # Github::PageLinks
