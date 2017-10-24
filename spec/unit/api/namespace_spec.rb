# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::API, '::namespace' do
  let(:foo_class) { Class.new(Github::API) }

  let(:foo_scopes_class) { Class.new(Github::API) }

  it "inherits namespace method" do
    stub_const("Foo", foo_class)
    expect(Foo).to respond_to(:namespace)
  end

  it "registers namespaced method" do
    stub_const("Foo", foo_class)
    stub_const("Foo::Scopes", foo_scopes_class)

    Foo.namespace(:scopes)

    foo_instance = Foo.new

    expect(foo_instance).to respond_to(:scopes)
    expect(foo_instance.scopes).to be_instance_of(Foo::Scopes)
  end

  it "doesn't redefine already existing namespace" do
    stub_const("Foo", foo_class)

    Foo.namespace(:scopes)

    expect {
      Foo.namespace(:scopes)
    }.to raise_error(ArgumentError, /namespace 'scopes' is already defined/)
  end
end
