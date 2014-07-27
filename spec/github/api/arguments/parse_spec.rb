# encoding: utf-8

require 'spec_helper'

describe Github::API::Arguments, '#parse' do

  let(:object) { described_class }

  let(:api)    { Github::Client::Repos.new }

  subject(:arguments) { object.new(api: api, required: required).parse(*args) }

  after { api.user =nil; api.repo = nil }

  context 'with required' do
    let(:required) { [:user, :repo] }
    let(:args)     { ['peter-murach', 'github', {page: 23}] }

    it "parses the request options" do
      expect(arguments.params).to eq({"page" => 23})
    end

    it "allows to retrieve user" do
      expect(arguments['user']).to eq('peter-murach')
      expect(arguments[:user]).to eq('peter-murach')
      expect(arguments.user).to eq('peter-murach')
    end

    it "allows to retrieve repo" do
      expect(arguments['repo']).to eq('github')
      expect(arguments[:repo]).to eq('github')
      expect(arguments.repo).to eq('github')
    end

    it "reports about unknown property" do
      expect(arguments['unknown']).to be_nil
      expect { arguments.unknown}.to raise_error(NoMethodError)
    end

    context 'when no arguments searches attributes hash' do
      let(:args) { nil }

      it 'asserts lack of presence of hash parameters' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context 'with nil argument' do
      let(:args) { [nil, 'github', {page: 23}] }

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError, /parameter/)
      end
    end

    context 'when arguments are inside hash' do
      let(:args) { [{user: 'peter-murach', repo: 'github', page: 23}] }

      it 'allows to retrieve required parameter' do
        expect(arguments['user']).to eq('peter-murach')
        expect(arguments[:user]).to eq('peter-murach')
        expect(arguments.user).to eq('peter-murach')
      end

      it "doesn't polute global namespace" do
        expect(arguments.api.user).to_not eq('peter-murach')
      end
    end
  end

  context 'with insufficient required' do
    let(:required) { [:user, :repo] }
    let(:args)     { ['peter-murach', {page: 23}] }

    it 'raises an error' do
      expect { arguments }.to raise_error(ArgumentError, /Wrong number/)
    end
  end

  context 'without required' do
    let(:required) { [] }
    let(:args)     { [{page: 23}] }

    it "parses request options" do
      expect(arguments.params).to eq({"page" => 23})
    end
  end
end
