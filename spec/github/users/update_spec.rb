# encoding: utf-8

require 'spec_helper'

describe Github::Users, '#get' do
  let(:user) { 'peter-murach' }
  let(:request_path) { "/user?access_token=#{OAUTH_TOKEN}" }

  before {
    subject.oauth_token = OAUTH_TOKEN
    stub_patch(request_path).with(user_params).
      to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  let(:user_params) {
    {
      "name" => "monalisa octocat",
      "email" => "octocat@github.com",
      "blog" => "https://github.com/blog",
      "company" => "GitHub",
      "location" => "San Francisco",
      "hireable" => true,
      "bio" => "There once..."
    }
  }

  context "resouce updated" do
    let(:body) { fixture('users/user.json') }
    let(:status) { 200 }

    it "should create resource successfully" do
      subject.update
      a_patch(request_path).with(user_params).should have_been_made
    end

    it "should return the resource" do
      user_resource = subject.update
      user_resource.should be_a Hashie::Mash
    end

    it "should get the resource information" do
      user_resource = subject.update
      user_resource.login.should == 'octocat'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.update }
  end

end # update
