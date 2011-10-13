require 'spec_helper'

describe Github::API do

  let(:api) { Github::API.new }

  before(:each) do
    @params = { 'a' => { :b => { 'c' => 1 }, 'd' => [ 'a', { :e => 2 }] } }
  end

  it "should stringify all the keys inside nested hash" do
    actual = api.send(:_normalize_params_keys, @params)
    expected = { 'a' => { 'b'=> { 'c' => 1 }, 'd' => [ 'a', { 'e'=> 2 }] } }
    actual.should == expected
  end

  it "should filter param keys" do
    valid = ['a', 'b', 'e']
    hash = {'a' => 1, 'b' => 3, 'c' => 2, 'd'=> 4, 'e' => 5 }
    actual = api.send(:_filter_params_keys, valid, hash)
    expected = {'a' => 1, 'b' => 3, 'e' => 5 }
    actual.should == expected
  end

end
