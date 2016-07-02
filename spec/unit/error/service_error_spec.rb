# encoding: utf-8

require 'spec_helper'

describe Github::Error::ServiceError do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }

  def test_request(body='')
    stub_get("/repos/#{user}/#{repo}/branches").
      to_return(:body => body, :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
  end

  it "handles empty message" do
    test_request
    expect {
      Github.repos.branches user, repo
    }.to raise_error(Github::Error::NotFound)
  end

  it "handles error message" do
    test_request :error => 'not found'
    expect {
      Github.repos.branches user, repo
    }.to raise_error(Github::Error::NotFound, /not found/)
  end

  it "handles nested errors" do
    test_request :errors => { :message => 'key is already in use' }
    expect {
      Github.repos.branches user, repo
    }.to raise_error(Github::Error::NotFound, /key is already in use/)
  end

  it 'decodes message' do
    test_request MultiJson.dump(:errors => { :message => 'key is already in use' })
    expect {
      Github.repos.branches user, repo
    }.to raise_error(Github::Error::NotFound, /key is already in use/)
  end


end # Github::Error::ServiceError
