# encoding: utf-8

require 'spec_helper'

describe Hash, 'deep_merge' do

  let(:hash) { { :a => 'a', :b => "b", :c => {:c1 => "c1", :c2 => "c2", :c3 => {:d1 => "d1"} } } }
  let(:other_hash) { { :a => 1, :b => "b", :c => {:c1 => 2, :c2 => "c2", :c3 => {:d1 => "d1", :d2 => "d2"} } } }

  subject { hash.deep_merge(other_hash) }

  it { expect(subject[:a]).to eql(1) }

  it { expect(subject[:b]).to eql("b") }

  it { expect(subject[:c][:c1]).to eql(2) }

  it { expect(subject[:c][:c2]).to eql("c2") }

  it { expect(subject[:c][:c3][:d1]).to eql("d1") }

  it { expect(subject[:c][:c3][:d2]).to eql("d2") }
end
