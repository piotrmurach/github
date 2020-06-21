# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::API, '#actions' do
  let(:api) { Github::Client::Repos::Contents }

  it "lists all available actions for an api class" do
    expect(api.actions).to eq([:archive, :create, :delete, :find, :get, :license, :readme, :update])
  end

  it "lists all available actions for an api instance" do
    expect(api.new.actions).to eq([:archive, :create, :delete, :find, :get, :license, :readme, :update])
  end
end
