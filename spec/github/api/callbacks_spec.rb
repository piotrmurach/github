# encoding: utf-8

require 'spec_helper'

class ApiTest < Github::API
  before_request :authorize, only: ['list']

  after_request :stats

  def list(a, b)
    (@called ||= []) << "list_#{a}_#{b}"
  end

  def get(a, b)
    (@called ||= []) << "get_#{a}_#{b}"
  end

  private

  def authorize
    (@called ||= []) << 'authorize'
  end

  def stats
    (@called ||= []) << 'stats'
  end
end

describe Github::API, '#callbacks' do
  it "retrieves only public api methods" do
    expect(ApiTest.request_methods.to_a - [
      'list',
      'list_with_callback_apitest',
      'list_without_callback_apitest',
      'get',
      'get_with_callback_apitest',
      'get_without_callback_apitest'
    ]).to be_empty
  end

  it "execute before callback" do
    api_test = ApiTest.new
    api_test.list(:foo, :bar)
    expect(api_test.instance_variable_get("@called")).to eq([
      'authorize',
      'list_foo_bar',
      'stats'
    ])
  end

  it "skips request" do
    api_test = ApiTest.new
    api_test.get(:foo, :bar)
    expect(api_test.instance_variable_get("@called")).to eq([
      'get_foo_bar',
      'stats'
    ])
  end
end
