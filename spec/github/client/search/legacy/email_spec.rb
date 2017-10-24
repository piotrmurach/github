# encoding: utf-8

require 'spec_helper'

describe Github::Client::Search::Legacy, '#email' do
  let(:keyword)      { 'api' }
  let(:request_path) { "/legacy/user/email/#{keyword}" }

  before do
    stub_get(request_path).
      to_return(body: body, status: status,
        headers: {content_type: "application/json; charset=utf-8"})
  end

  context "resource found" do
    let(:body)   { fixture('search/email.json') }
    let(:status) { 200 }

    it "should get the resources" do
      subject.email keyword
      a_get(request_path).should have_been_made
    end

    it "should get the resource through params hash" do
      subject.email email: keyword
      a_get(request_path).should have_been_made
    end

    it "should get user information" do
      user = subject.email email: keyword
      user.user.username.should == 'techno'
    end
  end
end
