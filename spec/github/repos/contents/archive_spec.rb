# encoding: utf-8

require 'spec_helper'

describe Github::Repos::Contents, '#get' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/#{archive_format}/#{ref}" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  let(:archive_format) { 'tarball' }
  let(:ref) { 'master' }
  let(:body) { '' }
  let(:status) { 302 }

  it "should get the resources" do
    subject.archive user, repo, :archive_format => archive_format, :ref => ref
    a_get(request_path).should have_been_made
  end
end
