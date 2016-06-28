# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Scopes, '#list' do
  let(:request_path) { "/user" }
  let(:body) { '[]' }
  let(:status) { 200 }

  before do
    stub_get(request_path).with(headers: {'Authorization' => "token 123abc"}).
      to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8",
                'X-Accepted-OAuth-Scopes' => "user",
                'X-OAuth-Scopes' => 'repo, user'
      })
  end

  it 'performs request with token as argument' do
    subject.list('123abc')
    expect(a_get(request_path)).to have_been_made
  end

  it 'performs request with token as option' do
    subject.list(token: '123abc')
    expect(a_get(request_path)).to have_been_made
  end

  it "raises error without token" do
    expect {
      subject.list
    }.to raise_error(ArgumentError, /Access token required/)
  end

  it 'queries oauth header' do
    expect(subject.list('123abc')).to eq(['repo', 'user'])
  end
end # list
