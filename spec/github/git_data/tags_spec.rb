require 'spec_helper'

describe Github::GitData::Tags, :type => :base do

  let(:sha) { "940bd336248efae0f9ee5bc7b2d5c985887b16ac" }

  it { described_class::VALID_TAG_PARAM_NAMES.should_not be_nil }

  describe "tag" do
    it { github.git_data.should respond_to :tag }
    it { github.git_data.should respond_to :get_tag }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/git/tags/#{sha}").
          to_return(:body => fixture('git_data/tag.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without sha" do
        expect { github.git_data.tag(user, repo, nil)}.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.git_data.tag user, repo, sha
        a_get("/repos/#{user}/#{repo}/git/tags/#{sha}").should have_been_made
      end

      it "should get tag information" do
        tag = github.git_data.tag user, repo, sha
        tag.tag.should eql "v0.0.1"
      end

      it "should return mash" do
        tag = github.git_data.tag user, repo, sha
        tag.should be_a Hashie::Mash
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/git/tags/#{sha}").
          to_return(:body => fixture('git_data/tag.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.git_data.tag user, repo, sha
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # tag

  describe "create_tag" do
    let(:inputs) {
      {
        "tag" => "v0.0.1",
        "message" => "initial version\n",
         "object" => {
           "type" => "commit",
           "sha" => "c3d0be41ecbe669545ee3e94d31ed9a4bc91ee3c",
           "url" => "https://api.github.com/repos/octocat/Hello-World/git/commits/c3d0be41ecbe669545ee3e94d31ed9a4bc91ee3c"
         },
        "tagger" => {
          "name" => "Scott Chacon",
          "email" => "schacon@gmail.com",
          "date" => "2011-06-17T14:53:35-07:00"
        }
      }
    }

    context "resouce created" do
      before do
        stub_post("/repos/#{user}/#{repo}/git/tags").
          with(:body => JSON.generate(inputs)).
          to_return(:body => fixture('git_data/tag.json'), :status => 201, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should create resource successfully" do
        github.git_data.create_tag user, repo, inputs
        a_post("/repos/#{user}/#{repo}/git/tags").with(inputs).should have_been_made
      end

      it "should return the resource" do
        tag = github.git_data.create_tag user, repo, inputs
        tag.should be_a Hashie::Mash
      end

      it "should get the tag information" do
        tag = github.git_data.create_tag user, repo, inputs
        tag.sha.should == sha
      end
    end

    context "failed to create resource" do
      before do
        stub_post("/repos/#{user}/#{repo}/git/tags").
          with(inputs).
          to_return(:body => fixture('git_data/tag.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should faile to retrieve resource" do
        expect {
          github.git_data.create_tag user, repo, inputs
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # create_tag

end # Github::GitData::Tags
