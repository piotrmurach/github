# encoding: utf-8

require 'spec_helper'

describe Github::API, '#namespace' do

  class Github::Foo < Github::API; end

  class Github::Foo::Test < Github::API; end

  let(:klass) { Github::Foo }

  let(:method_name) { :test }

  let(:options) { {arg: :custom} }

  subject(:instance) { klass.new }

  before { klass.namespace method_name }

  after { instance.instance_eval { undef :test } }

  it 'creates scope method' do
    expect(instance).to respond_to(method_name)
  end

  it 'returns scoped instance' do
    expect(instance.test).to be_a(Github::Foo::Test)
  end

  it 'passes options through' do
    expect(instance.adapter).to eql(:net_http)
    value = instance.test({adapter: :custom})
    expect(value.adapter).to eql(:custom)
  end

  it "doesn't redifine already existing scope" do
    expect(Github::API::Factory).to_not receive(:new)
    klass.namespace :test
  end
end
