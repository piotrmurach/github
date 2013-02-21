# encoding: utf-8

require 'spec_helper'

describe Github::Repos::Keys, '#edit' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}/keys/#{key_id}" }
  let(:key_id) { 1 }
  let(:inputs) { {:title => "octocat@octomac", :key => "ssh-rsa AAA..." } }

  before {
    stub_patch(request_path).with(inputs).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource edited successfully" do
    let(:body) { fixture("repos/key.json") }
    let(:status) { 200 }

    it { expect {subject.edit user, repo }.to raise_error(ArgumentError) }

    it "should edit the resource" do
      subject.edit user, repo, key_id, inputs
      a_patch(request_path).should have_been_made
    end

    it "should get the key information back" do
      key = subject.edit user, repo, key_id, inputs
      key.id.should == key_id
      key.title.should == 'octocat@octomac'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.edit user, repo, key_id, inputs }
  end

end # edit
