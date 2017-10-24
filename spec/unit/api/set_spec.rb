# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::API, '#set' do

  after { reset_authentication_for subject }

  it 'requires value to be set' do
    expect { subject.set :option }.to raise_error(ArgumentError)
  end

  context 'accpets more than one option' do
    before { subject.set user: 'user-name', repo: 'repo-name' }

    it 'sets user' do
      expect(subject.user).to eql('user-name')
    end

    it 'sets repo' do
      expect(subject.repo).to eql('repo-name')
    end
  end

  context 'defines accessors' do
    before { subject.set :branch, :master }

    it 'reads property default value' do
      expect(subject.branch).to eql(:master)
    end

    it 'sets property' do
      subject.branch = 'hotfix'
      expect(subject.branch).to eq('hotfix')
    end
  end
end
