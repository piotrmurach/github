require 'spec_helper'
require 'github_api/core_ext/hash'

describe Github::ParameterFilter do
  let(:github) { Github.new }
  let(:repos_instance) { Github::Repos.new }
  let(:block) {
    Proc.new do |repo|
      repo = repos_instance
    end
  }
  let(:hash) {  { :a => { :b => { :c => 1 } } }  }

  context '#filter!' do
    it 'removes unwanted keys from hash' do
      github.repos.filter!([:a], hash)
      hash.all_keys.should     include :a
      hash.all_keys.should_not include :b
      hash.all_keys.should_not include :c
    end

    it 'recursively filters inputs tree' do
      github.repos.filter!([:a, :b], hash)
      hash.all_keys.should_not include :c
    end

    it 'filters inputs tree only on top level' do
      github.repos.filter!([:a, :b], hash, :recursive => false)
      hash.all_keys.should include :c
    end
  end

#   context '#process_params' do
# 
#     it 'correctly yields current api instance' do
#       github.repos.should_receive(:process_params).and_yield repos_instance
#       github.repos.process_params(&block).should eq repos_instance
#     end
#   end

#   context '#normalize' do
#     it 'should call normalize on passed block' do
#       github.repos.process_params(&block).should respond_to :normalize
#     end
# 
#     it 'should normalize params inside block' do
#       github.repos.stub(:process_params).and_yield repos_instance
#       github.repos.process_params do |repo|
#         repo.normalize hash
#       end
#       hash.all_keys.should include 'a'
#       hash.all_keys.should_not include :a
#     end
#   end

#   context '#filter' do
#     it 'should call filter on passed block' do
#       github.repos.process_params(&block).should respond_to :filter
#     end
# 
#     it 'should filter params inside block' do
#       github.repos.stub(:process_params).and_yield repos_instance
#       github.repos.process_params do |repo|
#         repo.filter [:a], hash
#       end
#       hash.all_keys.should     include :a
#       hash.all_keys.should_not include :b
#     end
#   end

end # Github::ParameterFilter
