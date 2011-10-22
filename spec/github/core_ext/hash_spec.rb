require 'spec_helper'

describe Hash do

  before do
    Github.new
    @nested_hash = { 'a' => { 'b' => {'c' => 1 } } }
    @symbols = { :a => { :b => { :c => 1 } } }
  end

  it "should respond to except" do
    @nested_hash.should respond_to :except
  end

  it "should respond to except!" do
    @nested_hash.should respond_to :except!
  end

  it "should respond to symbolize_keys!" do
    @nested_hash.should respond_to :symbolize_keys!
  end

  it "should respond to symbolize_keys" do
    @nested_hash.should respond_to :symbolize_keys
  end

  it "should remove key from the hash" do
    @nested_hash.except('a').should be_empty
  end

  it "should convert nested keys to symbols" do
    @nested_hash.symbolize_keys!.should == @symbols
  end
end
