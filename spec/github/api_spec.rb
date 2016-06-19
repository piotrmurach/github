# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::API do
  context '#actions' do
    it 'dynamically adds actions inspection to classes inheriting from api' do
      repos = Github::Client::Repos
      expect(repos).to respond_to(:actions)
      expect(repos.new).to respond_to(:actions)
    end

    it 'ensures output contains api methods' do
      repos = Github::Client::Repos
      methods = [:method_a, :method_b]
      allow(repos).to receive(:instance_methods).and_return(methods)
      expect(repos.new.api_methods_in(repos)).to eq([:method_a, :method_b])
    end
  end

  context '#extract_basic_auth' do
    let(:options) { { basic_auth: 'piotr:secret' } }

    it "extracts login from :basic_auth param" do
      api = Github::API.new(options)
      expect(api.login).to eq('piotr')
    end

    it "extracts password from :basic_auth param" do
      api = Github::API.new(options)
      expect(api.password).to eq('secret')
    end
  end
end # Github::API
