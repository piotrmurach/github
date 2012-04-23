# encoding: utf-8

require 'spec_helper'
require 'github_api/s3_uploader'

describe Github::Repos::Downloads do
  let(:github) { Github.new }
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }

  after { github.user, github.repo, github.oauth_token = nil, nil, nil }

  it { described_class::VALID_DOWNLOAD_PARAM_NAMES.should_not be_nil }
  it { described_class::REQUIRED_PARAMS.should_not be_nil }

  describe "#list" do
    it { github.repos.downloads.should respond_to :list }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/downloads").
          to_return(:body => fixture('repos/downloads.json'), :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without username" do
        expect { github.repos.downloads.list }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.repos.downloads.list  user, repo
        a_get("/repos/#{user}/#{repo}/downloads").should have_been_made
      end

      it "should return array of resources" do
        downloads = github.repos.downloads.list user, repo
        downloads.should be_an Array
        downloads.should have(1).items
      end

      it "should be a mash type" do
        downloads = github.repos.downloads.list user, repo
        downloads.first.should be_a Hashie::Mash
      end

      it "should get download information" do
        downloads = github.repos.downloads.list user, repo
        downloads.first.name.should == 'new_file.jpg'
      end

      it "should yield to a block" do
        github.repos.downloads.should_receive(:list).
          with(user, repo).and_yield('web')
        github.repos.downloads.list(user, repo) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/downloads").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.repos.downloads.list user, repo
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # list

  describe "#get" do
    let(:download_id) { 1 }

    it { github.repos.downloads.should respond_to :find }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/downloads/#{download_id}").
          to_return(:body => fixture('repos/download.json'), :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without download id" do
        expect {
          github.repos.downloads.get user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.repos.downloads.get user, repo, download_id
        a_get("/repos/#{user}/#{repo}/downloads/#{download_id}").should have_been_made
      end

      it "should get download information" do
        download = github.repos.downloads.get user, repo, download_id
        download.id.should == download_id
        download.name.should == 'new_file.jpg'
      end

      it "should return mash" do
        download = github.repos.downloads.get user, repo, download_id
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
          github.repos.downloads.get user, repo, download_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # get

  describe "#delete" do
    let(:download_id) { 1 }

    context "resource edited successfully" do
      before do
        stub_delete("/repos/#{user}/#{repo}/downloads/#{download_id}").
          to_return(:body => '', :status => 204,
            :headers => { :content_type => "application/json; charset=utf-8"})
      end

      it "should fail to delete without 'user/repo' parameters" do
        expect { github.repos.downloads.delete }.to raise_error(ArgumentError)
      end

      it "should fail to delete resource without 'download_id'" do
        expect {
          github.repos.downloads.delete user, repo
        }.to raise_error(ArgumentError)
      end

      it "should delete the resource" do
        github.repos.downloads.delete user, repo, download_id
        a_delete("/repos/#{user}/#{repo}/downloads/#{download_id}").should have_been_made
      end
    end

    context "failed to edit resource" do
      before do
        stub_delete("/repos/#{user}/#{repo}/downloads/#{download_id}").
          to_return(:body => fixture("repos/download.json"), :status => 404,
            :headers => { :content_type => "application/json; charset=utf-8"})
      end

      it "should fail to find resource" do
        expect {
          github.repos.downloads.delete user, repo, download_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # delete

  describe "#create" do
    let(:inputs) { {:name => 'new_file.jpg', :size => 114034, :description => "Latest release", :content_type => 'text/plain'} }

    context "resouce created" do
      before do
        stub_post("/repos/#{user}/#{repo}/downloads").with(inputs).
          to_return(:body => fixture('repos/download_s3.json'), :status => 201, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should fail to create resource if 'name' input is missing" do
        expect {
          github.repos.downloads.create user, repo, inputs.except(:name)
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should failt to create resource if 'size' input is missing" do
        expect {
          github.repos.downloads.create user, repo, inputs.except(:size)
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should create resource successfully" do
        github.repos.downloads.create user, repo, inputs
        a_post("/repos/#{user}/#{repo}/downloads").with(inputs).should have_been_made
      end

      it "should return the resource" do
        download = github.repos.downloads.create user, repo, inputs
        download.should be_a Hashie::Mash
      end

      it "should get the download information" do
        download = github.repos.downloads.create user, repo, inputs
        download.name.should == 'new_file.jpg'
      end
    end

    context "failed to create resource" do
      before do
        stub_post("/repos/#{user}/#{repo}/downloads").with(inputs).
          to_return(:body => fixture('repos/download_s3.json'), :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should faile to retrieve resource" do
        expect {
          github.repos.downloads.create user, repo, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # create

  describe 'upload' do
    let(:resource) { stub(:resource) }
    let(:filename) { 'filename' }
    let(:res) { stub(:response, :body => 'success') }
    let(:uploader) { stub(:uploader, :send => res) }

    context 'resource uploaded' do
      before do
        Github::S3Uploader.stub(:new) { uploader }
      end

      it "should fail if resource is of incorrect type" do
        expect { github.repos.downloads.upload resource, nil }.to raise_error(ArgumentError)
      end

      it "should upload resource successfully" do
        res = stub(:response, :body => 'success')
        uploader = stub(:uploader, :send => res)
        Github::S3Uploader.should_receive(:new).with(resource, filename) { uploader }
        github.repos.downloads.upload(resource, filename).should == 'success'
      end
    end
  end # upload

end # Github::Repos::Downloads
