# encoding: utf-8

require 'spec_helper'

describe Github::API, '#actions' do
  let(:api) { Github::Client::Repos::Contents }

  context 'when class' do
    it "lists all available actions for an api" do
      expect(api.actions).to eq([:archive, :create, :delete, :find, :get, :readme, :update])
    end
  end

  context 'when instance' do
    it "lists all available actions for an api" do
      expect(api.new.actions).to eq([:archive, :create, :delete, :find, :get, :readme, :update])
    end
  end
end
