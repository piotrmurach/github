# encoding: utf-8

require 'spec_helper'
require 'github_api/core_ext/hash'

describe Github::Normalizer, '#normalize!' do
  let(:hash) { { 'a' => { :b => { 'c' => 1 }, 'd' => [ 'a', { :e => 2 }] } } }

  let(:klass) {
    Class.new do
      include Github::Normalizer
    end
  }

  subject(:instance) { klass.new }

  context '#normalize!' do
    it 'converts hash keys to string' do
      ['a', 'b', 'c'].each do |key|
        expect(subject.normalize!(hash).deep_key?(key)).to be_true
      end
      [:a, :b, :c].each do |key|
        expect(subject.normalize!(hash).deep_key?(key)).to be_false
      end
    end

    it "should stringify all the keys inside nested hash" do
      actual = subject.normalize! hash
      expected = { 'a' => { 'b'=> { 'c' => 1 }, 'd' => [ 'a', { 'e'=> 2 }] } }
      actual.should be_eql expected
    end
  end

end # Github::Normalizer
