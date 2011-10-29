require 'spec_helper'

describe Github::MimeType do

  let(:github) { Github.new }

  it "should lookup mime type for :full" do
    github.lookup_mime(:full).should == 'full+json'
  end

  it "should lookup mime type for :html" do
    github.lookup_mime(:html).should == 'html+json'
  end

  it "should lookup mime type for :html" do
    github.lookup_mime(:text).should == 'text+json'
  end

  it "should lookup mime type for :raw" do
    github.lookup_mime(:raw).should == 'raw+json'
  end

  it "should default to json if no parameters given" do
    Github.should_receive(:parse).and_return 'application/json'
    Github.parse.should == 'application/json'
  end

  it "should accept header for 'issue' request" do
    Github.should_receive(:parse).with(:issue, :full).
      and_return 'application/vnd.github-issue.full+json'
    Github.parse(:issue, :full).should == 'application/vnd.github-issue.full+json'
  end

  it "should accept header for 'isssue comment' request" do
    Github.should_receive(:parse).with(:issue_comment, :full).
      and_return 'application/vnd.github-issuecomment.full+json'
    Github.parse(:issue_comment, :full).should == 'application/vnd.github-issuecomment.full+json'
  end

  it "should accept header for 'commit comment' request" do
    Github.should_receive(:parse).with(:commit_comment, :full).
      and_return 'application/vnd.github-commitcomment.full+json'
    Github.parse(:commit_comment, :full).should == 'application/vnd.github-commitcomment.full+json'
  end

  it "should accept header for 'pull requst' request" do
    Github.should_receive(:parse).with(:pull_request, :full).
      and_return 'application/vnd.github-pull.full+json'
    Github.parse(:pull_request, :full).should == 'application/vnd.github-pull.full+json'
  end

  it "should accept header for 'pull comment' request" do
    Github.should_receive(:parse).with(:pull_comment, :full).
      and_return 'application/vnd.github-pullcomment.full+json'
    Github.parse(:pull_comment, :full).should == 'application/vnd.github-pullcomment.full+json'
  end

  it "should accept header for 'gist comment' request" do
    Github.should_receive(:parse).with(:gist_comment, :full).
      and_return 'application/vnd.github-gistcomment.full+json'
    Github.parse(:gist_comment, :full).should == 'application/vnd.github-gistcomment.full+json'
  end

  it "should accept header for 'blog' request" do
    Github.should_receive(:parse).with(:blob, :blob).
      and_return 'application/vnd.github-blob.raw'
    Github.parse(:blob, :blob).should == 'application/vnd.github-blob.raw'
  end

end # Github::MimeType
