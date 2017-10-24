# encoding: utf-8

require 'spec_helper'

describe Github::ResponseWrapper, '#eql?' do
  let(:env) {
     { :status => 404, :body => 'some',
      :response_headers => {'Content-Type' => 'text/plain'} }
  }
  let(:res) { Faraday::Response.new env }
  let(:object) { described_class.new res, nil }

  subject { object.eql?(other) }

  context 'with the same object' do
    let(:other) { object }

    it { expect(object.body).to eql('some') }

    it { should be_true }

    it 'is symmetric' do
      should eql(other.eql?(object))
    end
  end

  context 'with an equivalent object' do
    let(:other) { object.dup }

    it { should be_true }

    it 'is symmetric' do
      should eql(other.eql?(object))
    end
  end

  context 'with object having a nil body' do
    let(:other_env) { { :body => nil }}
    let(:other_res) { Faraday::Response.new other_env }
    let(:other) { described_class.new(other_res, nil) }

    it { expect(other.body).to be_nil }

    it { should be_false }

    it 'is symmetric' do
      should eql(other.eql?(object))
    end
  end

  context 'with object having different body' do
    let(:other_env) { { :body => ["some"] }}
    let(:other_res) { Faraday::Response.new other_env }
    let(:other) { described_class.new(other_res, nil) }

    it { expect(other.body).to eql(["some"]) }

    it { should be_false }

    it 'is symmetric' do
      should eql(other.eql?(object))
    end
  end

  context 'with object having no environment' do
    let(:other) {
      ::Class.new do
        def body; ['some'] end
      end.new
    }

    it { should be_false }

    it 'is symmetric' do
      should eql(other.eql?(object))
    end
  end

  context 'with object having no body' do
    let(:other) {
      ::Class.new do
        def env; end
      end.new
    }

    it { should be_false }

    it 'is symmetric' do
      should eql(other.eql?(object))
    end
  end
end
