# encoding: utf-8

require 'spec_helper'

describe Github::Client::GitData::References, '#list' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:ref) { "heads/master" }
  let(:request_path) { "/repos/#{user}/#{repo}/git/refs/#{ref}".gsub(/(\/)+/, '/') }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "get all the refernces based on sub-namespace" do
    let(:body) { fixture('git_data/references.json') }
    let(:status) { 200 }

    it { should respond_to :all }

    it "should fail to get resource without username" do
      expect { subject.list(nil, repo) }.to raise_error(ArgumentError)
    end

    context 'with invalid reference' do
      let(:ref) { '/branch/featureA' }

      it "should fail to call" do
        expect { subject.list(user, repo, :ref => ref) }.to_not raise_error()
      end
    end

    context 'with valid reference' do
      let(:ref) { 'heads/lleger-refactor' }

      it "should pass with valid reference" do
        expect { subject.list(user, repo, :ref => ref) }.to_not raise_error()
      end
    end

    context 'with valid reference and refs branch name' do
      let(:ref) { 'refactors/lleger-refactor' }

      it "should pass with valid reference" do
        expect { subject.list(user, repo, :ref => ref) }.to_not raise_error()
      end
    end

    context 'with valid renference and refs' do
      let(:ref) { 'refs/heads/lleger-refactor' }

      it "should pass with valid reference" do
        expect { subject.list(user, repo, :ref => ref) }.to_not raise_error()
      end
    end

    context 'with valid renference and refs with leading slash' do
      let(:ref) { '/refs/heads/lleger-refactor' }

      it "should pass with valid reference" do
        expect { subject.list(user, repo, :ref => ref) }.to_not raise_error()
      end
    end

    it "should get the resources" do
      subject.list user, repo, :ref => ref
      a_get(request_path).should have_been_made
    end

    it "should return array of resources" do
      references = subject.list user, repo, :ref => ref
      references.should be_an Enumerable
      references.should have(3).items
    end

    it "should be a mash type" do
      references = subject.list user, repo, :ref => ref
      references.first.should be_a Hashie::Mash
    end

    it "should get reference information" do
      references = subject.list user, repo, :ref => ref
      references.first.ref.should eql 'refs/heads/master'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list(user, repo, :ref => ref) { |obj| yielded << obj }
      yielded.should == result
    end
  end

  context "get all the references on the system" do
    let(:request_path) { "/repos/#{user}/#{repo}/git/refs" }
    let(:body) { fixture('git_data/references.json') }
    let(:status) { 200 }

    it "should get the resources" do
      subject.list user, repo
      a_get(request_path).should have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.list user, repo, :ref => ref }
  end

end # list
