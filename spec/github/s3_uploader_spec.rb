# encoding: utf-8

require 'spec_helper'
require 'github_api/s3_uploader'

describe Github::S3Uploader do
  let(:result) {
    double(:resource,
      'path' => 'downloads/octokit/github/droid',
      'acl'  => 'public-read',
      'name' => 'droid',
      "accesskeyid"=>"1DWESVTPGHQVTX38V182",
      "policy"=> "GlyYXRp==",
      "signature" => "fMGgiss1w=",
      "mime_type"=>"image/jpeg",
      "file"=> '',
      "s3_url" => 'https://github.s3.amazonaws.com/'
      )
  }
  let(:filename) { '/Users/octokit/droid.jpg' }
  let(:mapped_hash)  { {} }

  let(:uploader) { Github::S3Uploader.new result, filename }

  before do
    stub_post('https://github.s3.amazonaws.com/', '').
      to_return(:body => '', :status => 201, :headers => {})
    Faraday::UploadIO.stub(:new) { '' }
    Github::CoreExt::OrderedHash.stub(:[]) {  mapped_hash }
  end

  it 'checks for missing parameters' do
    resource = double(:resource)
    uploader = Github::S3Uploader.new resource, filename
    expect {
      uploader.send
    }.to raise_error(ArgumentError)
  end

  it 'serializes file' do
    Faraday::UploadIO.should_receive(:new) { '' }
    uploader.send
  end

  it 'sends request to amazon aws' do
    uploader.send
    a_post('https://github.s3.amazonaws.com/', '').with(mapped_hash).
      should have_been_made
  end

end # Github::S3Uploader
