# encoding: utf-8

require 'spec_helper'

describe Github::API, 'endpoint' do
  let(:endpoint) { "https://my-company/api/v3/" }
  let(:options) { {:endpoint => endpoint } }
  let(:path)  { "/repos/GitHub/issues-dev/issues" }

  subject(:api) { described_class.new(options) }

  before {
    stub_get(path, 'https://my-company/api/v3').
      to_return(:body => "[]", :status => 200, :headers =>{})
  }

  its(:endpoint) { should == endpoint }

  it "doesn't truncate endpoint" do
    expect { api.get_request(path) }.not_to raise_error()
  end
end
