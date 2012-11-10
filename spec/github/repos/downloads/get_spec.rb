# encoding: utf-8

require 'spec_helper'

describe Github::Repos::Downloads, '#get' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:download_id) { 1 }
  let(:request_path) { "/repos/#{user}/#{repo}/downloads/#{download_id}" }

  after { reset_authentication_for(subject) }

  before {
    stub_get(request_path).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
  }

  context "resource found" do
    let(:body)   { fixture('repos/download.json') }
    let(:status) { 200 }

    it { should respond_to :find }

    it "should fail to get resource without download id" do
      expect { subject.get user, repo, nil }.to raise_error(ArgumentError)
    end

    it "should get the resource" do
      subject.get user, repo, download_id
      a_get(request_path).should have_been_made
    end

    it "should get download information" do
      download = subject.get user, repo, download_id
      download.id.should == download_id
      download.name.should == 'new_file.jpg'
    end

    it "should return mash" do
      download = subject.get user, repo, download_id
      download.should be_a Hashie::Mash
    end
  end

  context "resource not found" do
    let(:body) { "" }
    let(:status) { [404, "Not Found"] }

    it "should fail to retrive resource" do
      expect {
        subject.get user, repo, download_id
      }.to raise_error(Github::Error::NotFound)
    end
  end
end # get

