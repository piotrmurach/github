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

RSpec.describe ConfigTest, '#property' do

  subject(:example) { described_class.new }

  it "doesn't have property" do
    expect(Github::API::Config.property?('test')).to eq(false)
  end

  it { expect(example).to respond_to(:test) }
  it { expect(example).to respond_to(:test=) }

  it 'defaults property to nil' do
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

RSpec.describe SubclassTest, '#property' do
  subject(:subclass) { described_class.new }

  it { expect(subclass.extra).to be_zero }

  it { expect(subclass).to respond_to(:test) }
  it { expect(subclass).to respond_to(:test=) }
  it { expect(subclass).to respond_to(:extra) }
  it { expect(subclass).to respond_to(:extra=) }
end
