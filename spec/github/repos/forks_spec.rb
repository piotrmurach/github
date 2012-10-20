# encoding: utf-8

require 'spec_helper'

describe Github::Repos::Forks do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }

  after { reset_authentication_for(subject) }

  describe "#list" do
    let(:request_path) { "/repos/#{user}/#{repo}/forks" }

    before do
      stub_get(request_path).
        to_return(:body => body, :status => status,
          :headers => {:content_type => "application/json; charset=utf-8"})
    end

    context "resource found" do
      let(:body)   { fixture('repos/forks.json') }
      let(:status) { 200 }

      it { should respond_to :all }

      it "should fail to get resource without username" do
        expect { subject.list }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        subject.list user, repo
        a_get(request_path).should have_been_made
      end

      it "should return array of resources" do
        forks = subject.list user, repo
        forks.should be_an Array
        forks.should have(1).items
      end

      it "should be a mash type" do
        forks = subject.list user, repo
        forks.first.should be_a Hashie::Mash
      end

      it "should get fork information" do
        forks = subject.list user, repo
        forks.first.name.should == 'Hello-World'
      end

      it "should yield to a block" do
        subject.should_receive(:list).with(user, repo).and_yield('web')
        subject.list(user, repo) { |param| 'web' }
      end
    end

    context "resource not found" do
      let(:body)   { "" }
      let(:status) { [404, "Not Found"] }

      it "should return 404 with a message 'Not Found'" do
        expect {
          subject.list user, repo
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # list

  describe "#create" do
    let(:request_path) { "/repos/#{user}/#{repo}/forks" }
    let(:inputs) { {:org => 'github'} }

    before do
      stub_post(request_path).with(inputs).
        to_return(:body => body, :status => status,
          :headers => {:content_type => "application/json; charset=utf-8"})
    end

    context "resouce created" do
      let(:body)   { fixture('repos/fork.json') }
      let(:status) { 202 }

      it "should create resource successfully" do
        subject.create(user, repo, inputs)
        a_post(request_path).with(inputs).should have_been_made
      end

      it "should return the resource" do
        fork = subject.create user, repo, inputs
        fork.should be_a Hashie::Mash
      end

      it "should get the fork information" do
        fork = subject.create user, repo, inputs
        fork.name.should == 'Hello-World'
      end
    end

    context "failed to create resource" do
      let(:body)   { "" }
      let(:status) { 404 }

      it "should faile to retrieve resource" do
        expect {
          subject.create user, repo, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # create

end # Github::Repos::Forks
