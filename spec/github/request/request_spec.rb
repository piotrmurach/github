# encoding: utf-8

require 'spec_helper'

describe Github::API, '#request' do
  let(:token)      { "2fdsfdo23fsdf3omkhen34n2jh" }
  let(:per_page)   { 100 }
  let(:path)       { "/api/v3/repos/GitHub/issues-dev/issues" }
  let(:url_prefix) { "https://my-company/api/v3/repos/GitHub/issues-dev/issues?access_token=#{token}&page=2&per_page=#{per_page}" }

  let(:conn) { Faraday::Connection.new }

  before {
    conn.url_prefix = url_prefix
    stub_get(path, 'https://my-company').
      with(:query => {'access_token' => token, :page => 2, :per_page => per_page}).
      to_return(:body => "", :status => 200, :headers =>{})
  }

  subject { described_class.new() }

  it 'sets connection path correctly' do
    expect(conn.path_prefix).to eql(path)
  end

  it 'responds to get request' do
    expect(subject).to respond_to(:get_request)
  end

  it 'handles enterprise uri correctly' do
    instance = Github::Request.new(:get, path, subject)
    instance.stub(:connection).and_return conn
    Github::Request.stub(:new).and_return instance
    expect { subject.get_request(path) }.not_to raise_error()
  end
end
