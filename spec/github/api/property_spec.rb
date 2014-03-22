# encoding: utf-8

require 'spec_helper'

describe Github::API::Config, '#property' do

  before(:all) {
    class Test < Github::API::Config
      property :test
      property :foo, default: :bar
      property :bar
    end
  }
  after(:all) { Object.send(:remove_const, :Test) }

  let(:example) { Test.new }

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
end
