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
      @nested_hash.should respond_to :except!
      copy = @nested_hash.dup
      copy.except!('b', 'a')
      copy.should be_empty
    end
  end

  context '#except' do
    it "should respond to except" do
      @nested_hash.should respond_to :except
    end

    it "should remove key from the hash" do
      @nested_hash.except('a').should be_empty
    end
  end

  context '#symbolize_keys' do
    it "should respond to symbolize_keys" do
      @nested_hash.should respond_to :symbolize_keys
    end
  end

  context '#symbolize_keys!' do
    it "should respond to symbolize_keys!" do
      @nested_hash.should respond_to :symbolize_keys!
    end

    it "should convert nested keys to symbols" do
      @nested_hash.symbolize_keys!.should == @symbols
    end
  end

  context '#serialize' do
    it "should respond to serialize" do
      @nested_hash.should respond_to :serialize
    end

    it "should serialize hash" do
      @hash.serialize.should == @serialized
    end
  end

  context '#deep_keys' do
    it "should respond to all_keys" do
      @nested_hash.should respond_to :deep_keys
    end

    it "should return all keys for nested hash" do
      @nested_hash.deep_keys.should eq ['a', 'b', 'c']
    end
  end

  context '#deep_key?' do
    it 'should find key inside nested hash' do
      @nested_hash.deep_key?('c').should be_true
    end
  end

end # Hash
