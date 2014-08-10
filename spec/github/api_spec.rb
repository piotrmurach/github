# encoding: utf-8

require 'spec_helper'

describe Github::API do
  subject { described_class.new(options) }

  it { described_class.included_modules.should include Github::Authorization }
  it { described_class.included_modules.should include Github::MimeType }
  it { described_class.included_modules.should include Github::Request::Verbs }

  context 'actions' do
    let(:options) { { } }
    let(:repos) { Github::Client::Repos }

    it { should respond_to :api_methods_in }

    it 'dynamically adds actions inspection to classes inheriting from api' do
      repos.should respond_to :actions
      repos.new.should respond_to :actions
    end

    it 'ensures output contains api methods' do
      methods = [ 'method_a', 'method_b']
      repos.stub(:instance_methods).and_return methods
      expect(subject.api_methods_in(repos)).to eq(['method_a', 'method_b'])
    end
  end

  context 'process_basic_auth' do
    let(:options) { { :basic_auth => 'login:password' } }

    its(:login) { should eq 'login' }

    its(:password) { should eq 'password' }

    its(:basic_auth) { should eq 'login:password' }
  end
end # Github::API
