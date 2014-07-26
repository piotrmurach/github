# encoding: utf-8

require 'spec_helper'

class ConfigTest < Github::API::Config
  property :test
  property :foo, default: :bar
  property :bar
end

class SubclassTest < ConfigTest
  property :test, default: 'Piotr'
  property :extra, default: 0
end

describe ConfigTest, '#property' do

  subject(:example) { described_class.new }

  it "doesnt have property" do
    expect(Github::API::Config.property?('test')).to be_false
  end

  it { expect(example).to respond_to(:test) }
  it { expect(example).to respond_to(:test=) }

  it 'defaults to nil' do
    expect(example.test).to eql nil
  end

  it 'defaults to :bar' do
    expect(example.foo).to eql :bar
  end

  it 'allows to write and read property' do
    subject.bar = :a
    expect(example.bar).to eql :a
  end

  it 'allows to fetch all properties' do
    expect(example.fetch.keys).to match_array([:bar, :foo, :test])
  end

  it 'allows to fetch individual property' do
    expect(example.fetch(:foo)).to eq(:bar)
  end
end

describe SubclassTest, '#property' do
  subject(:subclass) { described_class.new }

  it { expect(subclass.extra).to be_zero }

  it { expect(subclass).to respond_to(:test) }
  it { expect(subclass).to respond_to(:test=) }
  it { expect(subclass).to respond_to(:extra) }
  it { expect(subclass).to respond_to(:extra=) }
end

describe Github::API::Config, 'inheritance' do
  let(:top) { Class.new(Github::API::Config) }
  let(:middle) { Class.new(top) }
  let(:bottom) { Class.new(middle) }

  it "has no properties" do
    expect(top.property_names).to be_empty
    expect(middle.property_names).to be_empty
    expect(bottom.property_names).to be_empty
  end

  it "inherits properties down" do
    top.property :magic
    expect(top.property_names.include?(:magic)).to be_true
    expect(middle.property_names.include?(:magic)).to be_true
    expect(bottom.property_names.include?(:magic)).to be_true
  end

  it "doesn't inherit properties up" do
    middle.property :mushroom
    expect(top.property_names.include?(:mushroom)).to be_false
    expect(middle.property_names.include?(:mushroom)).to be_true
    expect(bottom.property_names.include?(:mushroom)).to be_true
  end

  it "allows to override a default option" do
    top.property :override
    middle.property :override, default: 66
    expect(bottom.property_names.include?(:override))
    expect(bottom.new.override).to eql(66)
  end

  it "allows to clear existing default" do
    top.property :simple, default: 0
    middle.property :simple, default: 1
    expect(top.new.simple).to eql(0)
    expect(middle.new.simple).to eql(1)
    expect(bottom.new.simple).to eql(1)
  end
end

