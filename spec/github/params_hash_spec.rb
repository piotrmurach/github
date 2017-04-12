# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::ParamsHash do
  let(:object) { described_class }

  subject(:params) { object.new(hash) }

  context 'when empty' do
    let(:hash) { {} }

    it { expect(params.options).to eq({:raw => false}) }

    it { expect(params.data).to eq({}) }

    it { expect(params.accept).to eq(nil) }
  end

  context 'converts key to string' do
    let(:hash) { {foo: 123 } }

    it { expect(params['foo']).to eql(123) }

    it { expect(params.data).to eql({"foo" => 123}) }
  end

  context 'media' do
    let(:hash) { {media: "raw"} }

    it 'parses media key' do
      expect(params.media).to eql('application/vnd.github.v3.raw+json')
    end
  end

  context 'with accept' do
    let(:hash) { {accept: "application/json"} }

    it 'overwrites media key' do
      expect(params.accept).to eql('application/json')
      expect(params.to_hash).to eq({'accept' => 'application/json'})
    end
  end

  context 'without accept' do
    let(:hash) { {} }

    it 'overwrites media key' do
      expect(params.accept).to be_nil
    end
  end

  context 'when data' do
    let(:hash) { {data: 'foobar'} }

    it 'extracts data key' do
      expect(params.data).to eql('foobar')
      expect(params.to_hash).to eql({'data' => 'foobar'})
    end
  end

  context 'when content_type' do
    let(:hash) { {content_type: 'application/octet-stream'} }

    it 'does not extract content_type key' do
      expect(params.options[:headers]).to be_nil
    end
  end

  context 'when header' do
    let(:hash) { {headers: {"X-GitHub-OTP" => "<2FA token>"}} }

    it "sets headers" do
      expect(params.options[:headers]).to eql({"X-GitHub-OTP" => "<2FA token>" })
    end
  end

  context 'merges defaults' do
    let(:hash) { { :homepage => "https://tty.github.io" }}
    let(:defaults) {
      { "homepage" => "https://github.com",
        "private"  => false}
    }

    it 'correctly updates values' do
      subject.merge_default(defaults)
      expect(params['homepage']).to eql("https://tty.github.io")
      expect(params['private']).to be_false
    end
  end

  context 'strict encode' do
    let(:hash) { {content: "puts 'hello ruby'"} }

    it { expect(params.strict_encode64('content')).to eql('cHV0cyAnaGVsbG8gcnVieSc=')  }
  end
end
