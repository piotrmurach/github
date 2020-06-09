# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Downloads, '#get' do
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

    it { is_expected.to respond_to :find }

    it { expect { subject.get }.to raise_error(ArgumentError) }

    it "should fail to get resource without download id" do
      expect { subject.get user, repo }.to raise_error(ArgumentError)
    end

    it "should get the resource" do
      subject.get user, repo, download_id
      expect(a_get(request_path)).to have_been_made
    end

    it "should get download information" do
      download = subject.get user, repo, download_id
      expect(download.id).to eq download_id
      expect(download.name).to eq 'new_file.jpg'
    end

    it "should return mash" do
      download = subject.get user, repo, download_id
      expect(download).to be_a Github::ResponseWrapper
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.get user, repo, download_id }
  end
end # get

