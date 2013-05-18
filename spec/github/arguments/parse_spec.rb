# encoding: utf-8

require 'spec_helper'

describe Github::Arguments, '#parse' do
  let(:api)    { Github::Repos.new }
  let(:object) { described_class.new api, 'required' => required }
  let(:arguments) { ['peter-murach', 'github', params] }
  let(:params) { { :page => 23 } }
  let(:required) { [:user, :repo] }

  subject { object.parse *arguments }

  after { api.user =nil; api.repo = nil }

  context 'with required arguments' do

    it { should == object }

    its(:params) { should == {"page" => 23} }

    context 'sets parameters' do
      it { subject.api.user.should == 'peter-murach' }

      it { subject.api.repo.should == 'github' }
    end

    context 'with no arguments search parameters hash' do
      let(:arguments) { nil }

      it 'asserts lack of presence of hash parameters' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context 'with nil argument' do
      let(:arguments) { [nil, 'github', params] }

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError, /parameter/)
      end
    end

    context 'with hash arguments' do
      let(:arguments) { [{:user => 'peter-murach', :repo => 'github'}.merge(params)]}

      it 'sets parameters' do
        subject.api.user.should == 'peter-murach'
      end
    end
  end

  context 'with less than required arguments' do
    let(:required) { [:user, :repo] }
    let(:arguments) { ['peter-murach', params] }

    it 'raises an error' do
      expect { subject }.to raise_error(ArgumentError, /wrong number/)
    end
  end

  context 'without required arguments' do
    let(:required) { [] }
    let(:arguments) { [params] }

    its(:params) { should == {"page" => 23} }
  end
end
