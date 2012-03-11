# encoding: utf-8

require 'spec_helper'

describe Github::Repos::Downloads do
  let(:github) { Github.new }
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }

  after { github.user, github.repo, github.oauth_token = nil, nil, nil }

  it { described_class::VALID_DOWNLOAD_PARAM_NAMES.should_not be_nil }
  it { described_class::REQUIRED_PARAMS.should_not be_nil }
  it { described_class::REQUIRED_S3_PARAMS.should_not be_nil }

  describe "downloads" do
    it { github.repos.should respond_to :downloads }
    it { github.repos.should respond_to :list_downloads }
    it { github.repos.should respond_to :get_downloads }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/downloads").
          to_return(:body => fixture('repos/downloads.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without username" do
        expect { github.repos.downloads }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.repos.downloads  user, repo
        a_get("/repos/#{user}/#{repo}/downloads").should have_been_made
      end

      it "should return array of resources" do
        downloads = github.repos.downloads user, repo
        downloads.should be_an Array
        downloads.should have(1).items
      end

      it "should be a mash type" do
        downloads = github.repos.downloads user, repo
        downloads.first.should be_a Hashie::Mash
      end

      it "should get download information" do
        downloads = github.repos.downloads user, repo
        downloads.first.name.should == 'new_file.jpg'
      end

      it "should yield to a block" do
        github.repos.should_receive(:downloads).with(user, repo).and_yield('web')
        github.repos.downloads(user, repo) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/downloads").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.repos.downloads user, repo
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # downloads

  describe "download" do
    let(:download_id) { 1 }

    it { github.repos.should respond_to :download }
    it { github.repos.should respond_to :get_download }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/downloads/#{download_id}").
          to_return(:body => fixture('repos/download.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without download id" do
        expect {
          github.repos.download(user, repo, nil)
        }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.repos.download user, repo, download_id
        a_get("/repos/#{user}/#{repo}/downloads/#{download_id}").should have_been_made
      end

      it "should get download information" do
        download = github.repos.download user, repo, download_id
        download.id.should == download_id
        download.name.should == 'new_file.jpg'
      end

      it "should return mash" do
        download = github.repos.download user, repo, download_id
        download.should be_a Hashie::Mash
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/downloads/#{download_id}").
          to_return(:body => fixture('repos/download.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.repos.download user, repo, download_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # download

  describe "delete_download" do
    let(:download_id) { 1 }

    context "resource edited successfully" do
      before do
        stub_delete("/repos/#{user}/#{repo}/downloads/#{download_id}").
          to_return(:body => '', :status => 204, :headers => { :content_type => "application/json; charset=utf-8"})
      end

      it "should fail to delete without 'user/repo' parameters" do
        github.user, github.repo = nil, nil
        expect { github.repos.delete_download }.to raise_error(ArgumentError)
      end

      it "should fail to delete resource without 'download_id'" do
        expect {
          github.repos.delete_download user, repo
        }.to raise_error(ArgumentError)
      end

      it "should delete the resource" do
        github.repos.delete_download user, repo, download_id
        a_delete("/repos/#{user}/#{repo}/downloads/#{download_id}").should have_been_made
      end
    end

    context "failed to edit resource" do
      before do
        stub_delete("/repos/#{user}/#{repo}/downloads/#{download_id}").
          to_return(:body => fixture("repos/download.json"), :status => 404, :headers => { :content_type => "application/json; charset=utf-8"})

      end

      it "should fail to find resource" do
        expect {
          github.repos.delete_download user, repo, download_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # delete_download

  describe "create_download" do
    let(:inputs) { {:name => 'new_file.jpg', :size => 114034, :description => "Latest release", :content_type => 'text/plain'} }

    context "resouce created" do
      before do
        stub_post("/repos/#{user}/#{repo}/downloads").with(inputs).
          to_return(:body => fixture('repos/download_s3.json'), :status => 201, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should fail to create resource if 'name' input is missing" do
        expect {
          github.repos.create_download user, repo, inputs.except(:name)
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should failt to create resource if 'size' input is missing" do
        expect {
          github.repos.create_download user, repo, inputs.except(:size)
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should create resource successfully" do
        github.repos.create_download user, repo, inputs
        a_post("/repos/#{user}/#{repo}/downloads").with(inputs).should have_been_made
      end

      it "should return the resource" do
        download = github.repos.create_download user, repo, inputs
        download.should be_a Hashie::Mash
      end

      it "should get the download information" do
        download = github.repos.create_download user, repo, inputs
        download.name.should == 'new_file.jpg'
      end
    end

    context "failed to create resource" do
      before do
        stub_post("/repos/#{user}/#{repo}/downloads").with(inputs).
          to_return(:body => fixture('repos/download_s3.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should faile to retrieve resource" do
        expect {
          github.repos.create_download(user, repo, inputs)
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # create_download

  describe 'upload' do
    let(:inputs) do
      { :name => 'new_file.jpg',
        :size => 114034,
        :description => "Latest release",
        :content_type => 'text/plain' }
    end
    let(:resource) { Hashie::Mash.new ::JSON.parse(fixture('repos/download_s3.json').read) }
    let(:file)     { 'filename' }

    context 'resource uploaded' do
      before do
        stub_post('', 'https://github.s3.amazonaws.com/').with(resource).
          to_return(:body => '', :status => 200, :headers => {})
      end

      it "should fail if resource is of incorrect type" do
        expect { github.repos.upload file, file }.to raise_error(ArgumentError)
      end

      it "should upload resource successfully" do
        github.repos.upload resource, file
        a_post('', 'https://github.s3.amazonaws.com').with(resource).should have_been_made
      end

    end
    context 'failed to upload resource' do
      before do
        stub_post('', 'https://github.s3.amazonaws.com/').with(resource).
          to_return(:body => '', :status => 404, :headers => {})
      end

      it "should faile to retrieve resource" do
        expect {
          github.repos.upload resource, file
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # upload

end # Github::Repos::Downloads
