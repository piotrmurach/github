require 'spec_helper'
require 'github_api/core_ext/hash'

describe Github::Normalizer do
  let(:github) { Github.new }
  let(:repos_instance) { Github::Repos.new }
  let(:hash) {  { :a => { :b => { :c => 1 } } }  }

  context '#normalize!' do
    it 'converts hash keys to string' do
      ['a', 'b', 'c'].each do |key|
        github.repos.normalize!(hash).all_keys.should include key
      end
      [:a, :b, :c].each do |key|
        github.repos.normalize!(hash).all_keys.should_not include key
      end
    end
  end

end # Github::Normalizer
