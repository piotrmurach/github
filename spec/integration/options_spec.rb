# encoding: utf-8

require 'spec_helper'

describe Github, 'options' do
  let(:default_adapter) { :net_http }
  let(:adapter) { :patron }
  let(:token) { '123' }
  let(:options) { { :adapter => adapter  } }

  context 'when different instances of the same class' do
    it 'instantiates the same api classes with different options' do
      repos  = Github::Client::Repos.new
      repos2 = Github::Client::Repos.new options

      expect(repos.object_id).to_not eql(repos2.object_id)

      expect(repos.adapter).to eql default_adapter
      expect(repos2.adapter).to eql adapter

      repos.adapter = adapter
      repos2.adapter = default_adapter

      expect(repos.adapter).to eql adapter
      expect(repos2.adapter).to eql default_adapter
    end

    it 'instantiates the same clients with different options' do
      client  = Github.new :oauth_token => 'client'
      client2 = Github.new :oauth_token => 'client2'

      expect(client.object_id).to_not eql(client2.object_id)

      expect(client.oauth_token).to eql 'client'
      expect(client2.oauth_token).to eql 'client2'
    end
  end

  context 'when different instances of the same chain' do
    it "inherits properties from client and doesn't pass them up the tree" do
      client = Github.new options
      repos  = client.repos

      expect(client.adapter).to eql(adapter)
      expect(repos.adapter).to eql(adapter)

      repos.adapter = default_adapter
      expect(client.adapter).to eql(adapter)
      expect(repos.adapter).to eql(default_adapter)

      client.oauth_token = token
      expect(client.oauth_token).to eql(token)
      expect(repos.oauth_token).to be_nil
    end

    it "inherits properties from api and doesn't pass them up the tree" do
      repos    = Github::Client::Repos.new options
      comments = repos.comments

      expect(repos.adapter).to eql(adapter)
      expect(comments.adapter).to eql(adapter)

      comments.adapter = default_adapter
      expect(repos.adapter).to eql(adapter)
      expect(comments.adapter).to eql(default_adapter)

      repos.oauth_token = token
      expect(repos.oauth_token).to eql(token)
      expect(comments.oauth_token).to be_nil
    end
  end

  context 'when setting attributes through accessors' do
    let(:default_endpoint) { 'https://api.github.com'}
    let(:endpoint) { 'https://my-company/api/v3' }
    let(:login) { 'Piotr' }

    it 'sets login on correct instance' do
      client = Github.new :login => login
      expect(Github.login).to be_nil
      expect(client.login).to eql login
    end

    it 'sets attribute' do
      client = Github.new options
      client.endpoint = endpoint
      expect(Github.endpoint).to eql default_endpoint
      expect(client.endpoint).to eql endpoint
    end

    it 'sets attribute through dsl' do
      client = Github.new do |config|
        config.endpoint = endpoint
      end
      expect(client.endpoint).to eql endpoint
      repos = client.repos do |config|
        config.adapter = adapter
      end
      expect(repos.endpoint).to eql endpoint
      expect(repos.adapter).to eql adapter
    end

    it 'updates current_options through api setters' do
      client = Github.new :endpoint => endpoint
      expect(client.repos.current_options[:endpoint]).to eql endpoint
      expect(client.repos.endpoint).to eql endpoint

      repos = client.repos
      repos.endpoint = default_endpoint

      expect(repos.endpoint).to eql default_endpoint
      expect(repos.current_options[:endpoint]).to eql default_endpoint
    end
  end

end # options
