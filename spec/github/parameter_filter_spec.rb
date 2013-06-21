# encoding: utf-8

require 'spec_helper'
require 'github_api/core_ext/hash'

describe Github::ParameterFilter, '#filter!' do
  let(:hash) {  { :a => { :b => { :c => 1 } } }  }

  let(:klass) {
    Class.new do
      include Github::ParameterFilter
    end
  }

  subject(:instance) { klass.new }

  it 'removes unwanted keys from hash' do
    instance.filter!([:a], hash)
    hash.all_keys.should     include :a
    hash.all_keys.should_not include :b
    hash.all_keys.should_not include :c
  end

  it 'recursively filters inputs tree' do
    instance.filter!([:a, :b], hash)
    hash.all_keys.should_not include :c
  end

  it 'filters inputs tree only on top level' do
    instance.filter!([:a, :b], hash, :recursive => false)
    hash.all_keys.should include :c
  end

end # Github::ParameterFilter
