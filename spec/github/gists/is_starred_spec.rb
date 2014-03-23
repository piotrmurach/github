# encoding: utf-8

require 'spec_helper'

describe Github::Client::Gists, '#unstar' do
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

    it 'should raise error if gist id not present' do
      expect { subject.starred? nil }.to raise_error(ArgumentError)
    end

    it 'should perform request' do
      subject.starred? gist_id
      a_get(request_path).should have_been_made
    end

    it 'should return true if gist is already starred' do
      subject.starred?(gist_id).should be_true
    end
  end

  context 'when gist is not starred' do
    let(:status) { 404 }

    it 'should return false if gist is not starred' do
      subject.starred?(gist_id).should be_false
    end
  end
end # starred?
