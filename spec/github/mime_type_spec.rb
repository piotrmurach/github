# encoding: utf-8

require 'spec_helper'

describe Github::MimeType do

  let(:object) { Class.new.extend(described_class) }

  context 'lookup' do
    it 'retrieves media type' do
      expect(object.lookup_media('text')).to eql('text+json')
    end

    it 'raises error on unkonwn media type' do
      expect { object.lookup_media('unknown') }.to raise_error(ArgumentError)
    end
  end

  context 'parse' do
    it 'accepts text' do
      expect(object.parse('text')).to eql('application/vnd.github.v3.text+json')
    end

    it 'accepts text+json' do
      expect(object.parse('text+json')).to eql('application/vnd.github.v3.text+json')
    end

    it 'accepts v3.text' do
      expect(object.parse('v3.text')).to eql('application/vnd.github.v3.text+json')
    end

    it 'accepts v3.text+json' do
      expect(object.parse('v3.text+json')).to eql('application/vnd.github.v3.text+json')
    end

    it 'accpets .v3.text' do
      expect(object.parse('.v3.text')).to eql('application/vnd.github.v3.text+json')
    end
  end

end # Github::MimeType
