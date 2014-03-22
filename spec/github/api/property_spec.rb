# encoding: utf-8

require 'spec_helper'

describe Github::API::Config, '#property' do

  let(:klass) {
    Class.new(Github::API::Config) {
      property :test
      property :attr, default: :bar
    }
  }

  subject { klass.new }

  it { should respond_to(:test) }
  it { should respond_to(:test=) }

  it 'defaults to nil' do
    expect(subject.test).to eql nil
  end

  it 'defaults to :bar' do
    expect(subject.attr).to eql :bar
  end

  it 'allows to write and read property' do
    subject.test = :foo
    expect(subject.test).to eql :foo
  end
end
