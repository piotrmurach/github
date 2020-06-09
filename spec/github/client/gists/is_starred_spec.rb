# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Gists, '#starred?' do
  let(:gist_id) { 1 }
  let(:request_path) { "/gists/#{gist_id}/star" }
  let(:body) { '' }
  let(:status) { 204 }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context 'when gist is starred' do
    let(:status) { 204 }

    it { expect { subject.starred? }.to raise_error(ArgumentError) }

    it 'raises error if gist id not present' do
      expect { subject.starred? nil }.to raise_error(ArgumentError)
    end

    it 'performs request' do
      subject.starred? gist_id
      expect(a_get(request_path)).to have_been_made
    end

    it 'returns true if gist is already starred' do
      expect(subject.starred?(gist_id)).to be true
    end
  end

  context 'when gist is not starred' do
    let(:status) { 404 }

    it 'returns false if gist is not starred' do
      expect(subject.starred?(gist_id)).to be false
    end
  end
end # starred?
