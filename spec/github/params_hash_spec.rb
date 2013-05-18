# encoding: utf-8

require 'spec_helper'

describe Github::ParamsHash do

  let(:hash) { }
  let(:object) { described_class }

  subject { object.new(hash) }

  context 'converts key to string' do
    let(:hash) { {:foo => 123 }}

    it { expect(subject).to be_a(Github::ParamsHash)}

    it { expect(subject['foo']).to eql(123) }

    it { expect(subject.data).to eql({"foo" => 123}) }
  end

  context 'extract data' do
    let(:hash) { {:data => 'foobar'} }

    it { expect(subject.data).to eql('foobar') }
  end

  context 'merges defaults' do
    let(:hash) { { :homepage => "https://tty.github.io" }}
    let(:defaults) {
      { "homepage"   => "https://github.com",
      "private"    => false}
    }

    it 'correctly updates values' do
      subject.merge_default(defaults)
      expect(subject['homepage']).to eql("https://tty.github.io")
      expect(subject['private']).to be_false
    end

  end

end
