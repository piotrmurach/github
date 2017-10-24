# encoding: utf-8

require 'spec_helper'

describe Github, '#configure' do
  subject { described_class }

  it "allows to configure settings" do
    yielded = nil
    Github.configure do |config|
      yielded = config
    end
    expect(yielded).to be_a(Github::Configuration)
  end
end
