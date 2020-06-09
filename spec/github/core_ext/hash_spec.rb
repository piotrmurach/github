# encoding: utf-8

require 'spec_helper'

describe Hash do

  before do
    Github.new
    @hash = { :a => 1, :b => 2, :c => 'e'}
    @serialized = "a=1&b=2&c=e"
    @nested_hash = { 'a' => { 'b' => {'c' => 1 } } }
    @symbols = { :a => { :b => { :c => 1 } } }
  end

  context '#except!' do
    it "should respond to except!" do
      expect(@nested_hash).to respond_to :except!
      copy = @nested_hash.dup
      copy.except!('b', 'a')
      expect(copy).to be_empty
    end
  end

  context '#except' do
    it "should respond to except" do
      expect(@nested_hash).to respond_to :except
    end

    it "should remove key from the hash" do
      expect(@nested_hash.except('a')).to be_empty
    end
  end

  context '#symbolize_keys' do
    it "should respond to symbolize_keys" do
      expect(@nested_hash).to respond_to :symbolize_keys
    end
  end

  context '#symbolize_keys!' do
    it "should respond to symbolize_keys!" do
      expect(@nested_hash).to respond_to :symbolize_keys!
    end

    it "should convert nested keys to symbols" do
      expect(@nested_hash.symbolize_keys!).to eq @symbols
    end
  end

  context '#serialize' do
    it "should respond to serialize" do
      expect(@nested_hash).to respond_to :serialize
    end

    it "should serialize hash" do
      expect(@hash.serialize).to eq @serialized
    end
  end

  context '#deep_keys' do
    it "should respond to all_keys" do
      expect(@nested_hash).to respond_to :deep_keys
    end

    it "should return all keys for nested hash" do
      expect(@nested_hash.deep_keys).to eq ['a', 'b', 'c']
    end
  end

  context '#deep_key?' do
    it 'should find key inside nested hash' do
      expect(@nested_hash.deep_key?('c')).to be true
    end
  end

end # Hash
