require 'spec_helper'
require 'github_api/core_ext/hash'

describe Github::Filter, :type => :base do

  let(:repos_instance) { Github::Repos.new }
  let(:block) {
    Proc.new do |repo|
      repo = repos_instance
    end
  }
  let(:hash) {  { :a => { :b => { :c => 1 } } }  }

  context '#process_params' do

    it 'correctly yields current api instance' do
      github.repos.should_receive(:process_params).and_yield repos_instance
      github.repos.process_params(&block).should eq repos_instance
    end
  end

  context '#normalize' do
    it 'should call normalize on passed block' do
      github.repos.process_params(&block).should respond_to :normalize
    end

    it 'should normalize params inside block' do
      github.repos.stub(:process_params).and_yield repos_instance
      github.repos.process_params do |repo|
        repo.normalize hash
      end
      hash.all_keys.should include 'a'
      hash.all_keys.should_not include :a
    end
  end

  context '#filter' do
    it 'should call filter on passed block' do
      github.repos.process_params(&block).should respond_to :filter
    end

    it 'should filter params inside block' do
      github.repos.stub(:process_params).and_yield repos_instance
      github.repos.process_params do |repo|
        repo.filter [:a], hash
      end
      hash.all_keys.should     include :a
      hash.all_keys.should_not include :b
    end
  end

  context '#_normalize_params_keys' do
    it 'converts hash keys to string' do
      ['a', 'b', 'c'].each do |key|
        github.repos._normalize_params_keys(hash).all_keys.should include key
      end
      [:a, :b, :c].each do |key|
        github.repos._normalize_params_keys(hash).all_keys.should_not include key
      end
    end
  end

  context '#_filter_params_keys' do
    it 'removes unwanted keys from hash' do
      github.repos._filter_params_keys([:a], hash)
      hash.all_keys.should     include :a
      hash.all_keys.should_not include :b
      hash.all_keys.should_not include :c
    end
  end

end # Github::Filter
