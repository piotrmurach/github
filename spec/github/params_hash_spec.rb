# encoding: utf-8

require 'spec_helper'

describe Github::ParamsHash do

  let(:hash) { }
  let(:object) { described_class }

  subject { object.new(hash) }

  context 'converts key to string' do
    let(:hash) { {:foo => 123 }}

    it { expect(subject['foo']).to eql(123) }

    it { expect(subject.data).to eql(hash) }
  end

  context 'extract data' do
    let(:hash) { {:data => 'foobar'} }

    it { expect(subject.data).to eql('foobar') }
  end
end
