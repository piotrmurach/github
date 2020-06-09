# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::API::Config, 'inheritance' do
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
    expect(top.property_names.include?(:magic)).to be true
    expect(middle.property_names.include?(:magic)).to be true
    expect(bottom.property_names.include?(:magic)).to be true
  end

  it "doesn't inherit properties up" do
    middle.property :mushroom
    expect(top.property_names.include?(:mushroom)).to be false
    expect(middle.property_names.include?(:mushroom)).to be true
    expect(bottom.property_names.include?(:mushroom)).to be true
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
