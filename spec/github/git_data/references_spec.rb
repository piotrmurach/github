require 'spec_helper'

describe Github::GitData::References, :type => :base do

  let(:ref) { "heads/master" }
  let(:sha) { "3a0f86fb8db8eea7ccbb9a95f325ddbedfb25e15" }

  it { described_class::VALID_REF_PARAM_NAMES.should_not be_nil }
  it { described_class::VALID_REF_PARAM_VALUES.should_not be_nil }

  describe "references" do

    context 'check aliases' do
      it { github.git_data.should respond_to :references }
      it { github.git_data.should respond_to :list_references }
      it { github.git_data.should respond_to :get_all_references }
    end

    context "get all the refernces based on sub-namespace" do
      before do
        stub_get("/repos/#{user}/#{repo}/git/refs/#{ref}").
          to_return(:body => fixture('git_data/references.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without username" do
        github.user, github.repo = nil, nil
        expect { github.git_data.references }.to raise_error(ArgumentError)
      end

      it "should fail to call with invalid reference" do
        expect {
          github.git_data.references user, repo, 'branch'
        }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.git_data.references user, repo, ref
        a_get("/repos/#{user}/#{repo}/git/refs/#{ref}").should have_been_made
      end

      it "should return array of resources" do
        references = github.git_data.references user, repo, ref
        references.should be_an Array
        references.should have(3).items
      end

      it "should be a mash type" do
        references = github.git_data.references user, repo, ref
        references.first.should be_a Hashie::Mash
      end

      it "should get reference information" do
        references = github.git_data.references user, repo, ref
        references.first.ref.should eql 'refs/heads/master'
      end

      it "should yield to a block" do
        github.git_data.should_receive(:references).with(user, repo, ref).and_yield('web')
        github.git_data.references(user, repo, ref) { |param| 'web' }
      end
    end

    context "get all the references on the system" do
      before do
        stub_get("/repos/#{user}/#{repo}/git/refs").
          to_return(:body => fixture('git_data/references.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the resources" do
        github.git_data.references user, repo
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
          github.git_data.references user, repo, ref
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # references

  describe "reference" do
    it { github.git_data.should respond_to :reference }
    it { github.git_data.should respond_to :get_reference }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/git/refs/#{ref}").
          to_return(:body => fixture('git_data/reference.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without ref" do
        expect { github.git_data.reference(user, repo, nil)}.to raise_error(ArgumentError)
      end

      it "should fail to get resource with wrong ref" do
        expect {
          github.git_data.reference user, repo, 'branch'
        }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.git_data.reference user, repo, ref
        a_get("/repos/#{user}/#{repo}/git/refs/#{ref}").should have_been_made
      end

      it "should get reference information" do
        reference = github.git_data.reference user, repo, ref
        reference.first.ref.should eql "refs/heads/sc/featureA"
      end

      it "should return mash" do
        reference = github.git_data.reference user, repo, ref
        reference.first.should be_a Hashie::Mash
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/git/refs/#{ref}").
          to_return(:body => fixture('git_data/reference.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.git_data.reference user, repo, ref
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # reference

  describe "create_reference" do
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
          with(:body => JSON.generate(inputs.except('unrelated'))).
          to_return(:body => fixture('git_data/reference.json'), :status => 201, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to create resource if 'ref' input is missing" do
        expect {
          github.git_data.create_reference user, repo, inputs.except('ref')
        }.to raise_error(ArgumentError)
      end

      it "should fail to create resource if 'sha' input is missing" do
        expect {
          github.git_data.create_reference user, repo, inputs.except('sha')
        }.to raise_error(ArgumentError)
      end

      it "should fail to create resource if 'ref' is wrong" do
        expect {
          github.git_data.create_reference user, repo, 'branch'
        }.to raise_error(ArgumentError)
      end

      it "should create resource successfully" do
        github.git_data.create_reference user, repo, inputs
        a_post("/repos/#{user}/#{repo}/git/refs").with(inputs).should have_been_made
      end

      it "should return the resource" do
        reference = github.git_data.create_reference user, repo, inputs
        reference.first.should be_a Hashie::Mash
      end

      it "should get the reference information" do
        reference = github.git_data.create_reference user, repo, inputs
        reference.first.ref.should eql 'refs/heads/sc/featureA'
      end
    end

    context "failed to create resource" do
      before do
        stub_post("/repos/#{user}/#{repo}/git/refs").with(inputs).
          to_return(:body => fixture('git_data/reference.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should faile to retrieve resource" do
        expect {
          github.git_data.create_reference user, repo, inputs
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # create_reference

  describe "update_reference" do
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
          with(:body => JSON.generate(inputs.except('unrelated'))).
          to_return(:body => fixture('git_data/reference.json'), :status => 201, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to create resource if 'sha' input is missing" do
        expect {
          github.git_data.update_reference user, repo, ref, inputs.except('sha')
        }.to raise_error(ArgumentError)
      end

      it "should fail to create resource if 'ref' is wrong" do
        expect {
          github.git_data.update_reference user, repo, 'branch', inputs
        }.to raise_error(ArgumentError)
      end

      it "should update resource successfully" do
        github.git_data.update_reference user, repo, ref, inputs
        a_patch("/repos/#{user}/#{repo}/git/refs/#{ref}").with(inputs).should have_been_made
      end

      it "should return the resource" do
        reference = github.git_data.update_reference user, repo, ref, inputs
        reference.first.should be_a Hashie::Mash
      end

      it "should get the reference information" do
        reference = github.git_data.update_reference user, repo, ref, inputs
        reference.first.ref.should eql 'refs/heads/sc/featureA'
      end
    end

    context "failed to create resource" do
      before do
        stub_patch("/repos/#{user}/#{repo}/git/refs/#{ref}").with(inputs).
          to_return(:body => fixture('git_data/reference.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should faile to retrieve resource" do
        expect {
          github.git_data.update_reference user, repo, ref, inputs
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # update_reference

end # Github::GitData::References
