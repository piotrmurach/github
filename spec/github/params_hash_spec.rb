# encoding: utf-8

require 'spec_helper'

describe Github::ParamsHash do
  let(:object) { described_class }

  subject { object.new(hash) }

  context 'converts key to string' do
    let(:hash) { {:foo => 123 }}

    it { expect(subject).to be_a(Github::ParamsHash)}

    it { expect(subject['foo']).to eql(123) }

    it { expect(subject.data).to eql({"foo" => 123}) }
  end

  context 'media' do
    let(:hash) { {:media => "raw"} }

    it 'parses media key' do
      expect(subject.media).to eql('application/vnd.github.v3.raw+json')
    end
  end

  context 'with accept' do
    let(:hash) { {:accept => "application/json"} }

    it 'overwrites media key' do
      expect(subject.accept).to eql('application/json')
    end
  end

  context 'without accept' do
    let(:hash) { {} }

    it 'overwrites media key' do
      expect(subject.accept).to be_nil
    end
  end

  context 'extract data' do
    let(:hash) { {:data => 'foobar'} }

    it { expect(subject.data).to eql('foobar') }
  end

  context 'extracts options headers' do
    let(:hash) { {:content_type => 'application/octet-stream'} }

    it { expect(subject.options[:headers]).to eql(hash) }
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

  context 'strict encode' do
    let(:hash) { { :content => "puts 'hello ruby'"} }

    it { expect(subject.strict_encode64('content')).to eql('cHV0cyAnaGVsbG8gcnVieSc=')  }
  end
end
