# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Authorizations, 'two-factor' do
  let(:basic_auth) { 'login:password' }
  let(:host) { "https://api.github.com" }

  it "fails with known OTP error" do
    stub_get("/authorizations/1", host).to_return(
      status: 401,
      headers: {
        content_type: 'application/json',
        'X-GitHub-OTP' => 'required; sms'
      },
      body: {message: "Require two-factor authentication OTP token."}.to_json
    )
    expect {
      described_class.new(basic_auth: 'login:password').get(1)
    }.to raise_error(Github::Error::Unauthorized, /Require two-factor/)
  end
end
