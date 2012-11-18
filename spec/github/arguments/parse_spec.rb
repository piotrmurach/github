# encoding: utf-8

require 'spec_helper'

describe Github::Arguments, '#parse' do
  let(:api)    { Github::Repos.new }
  let(:object) { described_class.new api, 'required' => required }
  let(:arguments) { ['peter-murach', 'github', params] }
  let(:params) { { :page => 23 } }

  subject { object.parse *arguments }

  context 'with required arguments' do
    let(:required) { [:user, :repo] }

    it { should == object }

    its(:params) { should == params }

    it 'sets parameters' do
      subject.api.user.should == 'peter-murach'
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

    its(:params) { should == params }
  end
end
