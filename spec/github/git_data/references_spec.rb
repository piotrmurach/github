# encoding: utf-8

require 'spec_helper'

describe Github::GitData::References do
  let(:github) { Github.new }
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:ref) { "heads/master" }
  let(:sha) { "3a0f86fb8db8eea7ccbb9a95f325ddbedfb25e15" }

  after { reset_authentication_for github }

  it { described_class::VALID_REF_PARAM_NAMES.should_not be_nil }
  it { described_class::VALID_REF_PARAM_VALUES.should_not be_nil }

  describe "#list" do
    it { github.git_data.references.should respond_to :all }


    context "get all the refernces based on sub-namespace" do
      before do
        stub_get("/repos/#{user}/#{repo}/git/refs/#{ref}").
          to_return(:body => fixture('git_data/references.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without username" do
        expect {
          github.git_data.references.list nil, repo
        }.to raise_error(ArgumentError)
      end

      it "should fail to call with invalid reference" do
        expect {
          github.git_data.references.list user, repo, :ref => '/branch/featureA'
        }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.git_data.references.list user, repo, :ref => ref
        a_get("/repos/#{user}/#{repo}/git/refs/#{ref}").should have_been_made
      end

      it "should return array of resources" do
        references = github.git_data.references.list user, repo, :ref => ref
        references.should be_an Array
        references.should have(3).items
      end

      it "should be a mash type" do
        references = github.git_data.references.list user, repo, :ref => ref
        references.first.should be_a Hashie::Mash
      end

      it "should get reference information" do
        references = github.git_data.references.list user, repo, :ref => ref
        references.first.ref.should eql 'refs/heads/master'
      end

      it "should yield to a block" do
        github.git_data.references.should_receive(:list).
          with(user, repo, :ref => ref).and_yield('web')
        github.git_data.references.list(user, repo, :ref => ref) { |param| 'web' }
      end
    end

    context "get all the references on the system" do
      before do
        stub_get("/repos/#{user}/#{repo}/git/refs").
          to_return(:body => fixture('git_data/references.json'), :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the resources" do
        github.git_data.references.list user, repo
        a_get("/repos/#{user}/#{repo}/git/refs").should have_been_made
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/git/refs/#{ref}").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.git_data.references.list user, repo, :ref => ref
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # list

  describe "#get" do
    it { github.git_data.references.should respond_to :find }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/git/refs/#{ref}").
          to_return(:body => fixture('git_data/reference.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without ref" do
        expect {
          github.git_data.references.get user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should fail to get resource with wrong ref" do
        expect {
          github.git_data.references.get user, repo, '/branch'
        }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.git_data.references.get user, repo, ref
        a_get("/repos/#{user}/#{repo}/git/refs/#{ref}").should have_been_made
      end

      it "should get reference information" do
        reference = github.git_data.references.get user, repo, ref
        reference.first.ref.should eql "refs/heads/sc/featureA"
      end

      it "should return mash" do
        reference = github.git_data.references.get user, repo, ref
        reference.first.should be_a Hashie::Mash
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/git/refs/#{ref}").
          to_return(:body => '', :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.git_data.references.get user, repo, ref
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # get

  describe "#create" do
    let(:inputs) {
      {
        "ref" => "refs/heads/master",
        "sha" => "827efc6d56897b048c772eb4087f854f46256132",
        "unrelated" => 'giberrish'
      }
    }

    context "resouce created" do
      before do
        stub_post("/repos/#{user}/#{repo}/git/refs").
          with(inputs.except('unrelated')).
          to_return(:body => fixture('git_data/reference.json'), :status => 201,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to create resource if 'ref' input is missing" do
        expect {
          github.git_data.references.create user, repo, inputs.except('ref')
        }.to raise_error(ArgumentError)
      end

      it "should fail to create resource if 'sha' input is missing" do
        expect {
          github.git_data.references.create user, repo, inputs.except('sha')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should fail to create resource if 'ref' is wrong" do
        expect {
          github.git_data.references.create user, repo, :ref => '/heads/master', :sha => '13t2a1r3'
        }.to raise_error(ArgumentError)
      end

      it "should create resource successfully" do
        github.git_data.references.create user, repo, inputs
        a_post("/repos/#{user}/#{repo}/git/refs").with(inputs).should have_been_made
      end

      it "should return the resource" do
        reference = github.git_data.references.create user, repo, inputs
        reference.first.should be_a Hashie::Mash
      end

      it "should get the reference information" do
        reference = github.git_data.references.create user, repo, inputs
        reference.first.ref.should eql 'refs/heads/sc/featureA'
      end
    end

    context "failed to create resource" do
      before do
        stub_post("/repos/#{user}/#{repo}/git/refs").with(inputs).
          to_return(:body => '', :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should faile to retrieve resource" do
        expect {
          github.git_data.references.create user, repo, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # create

  describe "#update" do
    let(:inputs) {
      {
        "sha" => "827efc6d56897b048c772eb4087f854f46256132",
        "force" => true,
        "unrelated" => 'giberrish'
      }
    }

    context "resouce updated" do
      before do
        stub_patch("/repos/#{user}/#{repo}/git/refs/#{ref}").
          with(inputs.except('unrelated')).
          to_return(:body => fixture('git_data/reference.json'), :status => 201, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to update resource if 'sha' input is missing" do
        expect {
          github.git_data.references.update user, repo, ref, inputs.except('sha')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should fail to update resource if 'ref' is wrong" do
        expect {
          github.git_data.references.update user, repo, nil, inputs
        }.to raise_error(ArgumentError)
      end

      it "should update resource successfully" do
        github.git_data.references.update user, repo, ref, inputs
        a_patch("/repos/#{user}/#{repo}/git/refs/#{ref}").
          with(inputs).should have_been_made
      end

      it "should return the resource" do
        reference = github.git_data.references.update user, repo, ref, inputs
        reference.first.should be_a Hashie::Mash
      end

      it "should get the reference information" do
        reference = github.git_data.references.update user, repo, ref, inputs
        reference.first.ref.should eql 'refs/heads/sc/featureA'
      end
    end

    context "failed to update resource" do
      before do
        stub_patch("/repos/#{user}/#{repo}/git/refs/#{ref}").with(inputs).
          to_return(:body => '', :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should faile to retrieve resource" do
        expect {
          github.git_data.references.update user, repo, ref, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # update

  describe "#delete" do
    it { github.git_data.references.should respond_to :remove }

    context "resouce delete" do
      before do
        stub_delete("/repos/#{user}/#{repo}/git/refs/#{ref}").
          to_return(:body => '', :status => 204, 
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to delete resource if 'ref' input is missing" do
        expect {
          github.git_data.references.delete user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should delete resource successfully" do
        github.git_data.references.delete user, repo, ref
        a_delete("/repos/#{user}/#{repo}/git/refs/#{ref}").should have_been_made
      end
    end

    context "failed to create resource" do
      before do
        stub_delete("/repos/#{user}/#{repo}/git/refs/#{ref}").
          to_return(:body => '', :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should faile to retrieve resource" do
        expect {
          github.git_data.references.delete user, repo, ref
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # delete

end # Github::GitData::References
