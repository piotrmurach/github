# encoding: utf-8

require 'spec_helper'

describe Github::Gists do
  let(:github) { Github.new }
  let(:user) { 'peter-murach' }
  let(:gist_id) { '1' }

  after { reset_authentication_for(github) }

  describe "#list" do
    it { github.gists.should respond_to :all }

    context "- unauthenticated user" do
      context "resource found" do
        before do
          stub_get("/users/#{user}/gists").
            to_return(:body => fixture('gists/gists.json'), :status => 200,
              :headers => {:content_type => "application/json; charset=utf-8"})
        end

        it "should get the resources" do
          github.gists.list :user => user
          a_get("/users/#{user}/gists").should have_been_made
        end

        it "should return array of resources" do
          gists = github.gists.list :user => user
          gists.should be_an Array
          gists.should have(1).items
        end

        it "should be a mash type" do
          gists = github.gists.list :user => user
          gists.first.should be_a Hashie::Mash
        end

        it "should get gist information" do
          gists = github.gists.list :user => user
          gists.first.user.login.should == 'octocat'
        end

        it "should yield to a block" do
          github.gists.should_receive(:list).with(user).and_yield('web')
          github.gists.list(user) { |param| 'web' }
        end
      end

      context "resource not found" do
        before do
          stub_get("/users/#{user}/gists").
            to_return(:body => "", :status => [404, "Not Found"])
        end

        it "should return 404 with a message 'Not Found'" do
          expect {
            github.gists.list :user => user
          }.to raise_error(Github::Error::NotFound)
        end
      end
    end # unauthenticated user

    context '- public' do
      before do
        stub_get("/gists/public").
          to_return(:body => fixture('gists/gists.json'), :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the resources" do
        github.gists.list
        a_get("/gists/public").should have_been_made
      end
    end

    context '- authenticated user' do
      before do
        github.oauth_token = OAUTH_TOKEN
        stub_get("/gists").
          with(:query => {:access_token => OAUTH_TOKEN}).
          to_return(:body => fixture('gists/gists.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end
      # after { github.oauth_token = nil }

      it "should get the resources" do
        github.gists.list
        a_get("/gists").with(:query => {:access_token => OAUTH_TOKEN}).
          should have_been_made
      end
    end
  end # list

  describe "#starred" do
    context "resource found" do
      before do
        stub_get("/gists/starred").
          to_return(:body => fixture('gists/gists.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the resources" do
        github.gists.starred
        a_get("/gists/starred").should have_been_made
      end

      it "should return array of resources" do
        gists = github.gists.starred
        gists.should be_an Array
        gists.should have(1).items
      end

      it "should be a mash type" do
        gists = github.gists.starred
        gists.first.should be_a Hashie::Mash
      end

      it "should get gist information" do
        gists = github.gists.starred
        gists.first.user.login.should == 'octocat'
      end

      it "should yield to a block" do
        github.gists.should_receive(:starred).and_yield('web')
        github.gists.starred() { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/gists/starred").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.gists.starred
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # starred

  describe "#get" do
    it { github.gists.should respond_to :find }

    context "resource found" do
      before do
        stub_get("/gists/#{gist_id}").
          to_return(:body => fixture('gists/gist.json'), :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without gist id" do
        expect { github.gists.get nil }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.gists.get gist_id
        a_get("/gists/#{gist_id}").should have_been_made
      end

      it "should get gist information" do
        gist = github.gists.get gist_id
        gist.id.should eq gist_id
        gist.user.login.should == 'octocat'
      end

      it "should return mash" do
        gist = github.gists.get gist_id
        gist.should be_a Hashie::Mash
      end
    end

    context "resource not found" do
      before do
        stub_get("/gists/#{gist_id}").
          to_return(:body => fixture('gists/gist.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.gists.get gist_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # get

  describe "#create" do
    let(:inputs) {
      {
        "description" => "the description for this gist",
        "public" => true,
        "files" => {
          "file1.txt" => {
            "content" => "String file contents"
          }
        },
      }
    }

    context "resouce created" do
      before do
        stub_post("/gists").
          with(inputs).
          to_return(:body => fixture('gists/gist.json'),
            :status => 201,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to create resource if 'files' input is missing" do
        expect {
          github.gists.create inputs.except('files')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should fail to create resource if 'content' input is missing" do
        pending 'add validation for nested attributes'
        expect {
          github.gists.create inputs.except('content')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should fail to create resource if 'public' input is missing" do
        expect {
          github.gists.create inputs.except('public')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should create resource successfully" do
        github.gists.create inputs
        a_post("/gists").with(inputs).should have_been_made
      end

      it "should return the resource" do
        gist = github.gists.create inputs
        gist.should be_a Hashie::Mash
      end

      it "should get the gist information" do
        gist = github.gists.create inputs
        gist.user.login.should == 'octocat'
      end
    end

    context "failed to create resource" do
      before do
        stub_post("/gists").with(inputs).
          to_return(:body => fixture('gists/gist.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should faile to retrieve resource" do
        expect {
          github.gists.create inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # create

  describe "#edit" do
    let(:inputs) {
      {
        "description" => "the description for this gist",
        "files" => {
          "file1.txt" => {
            "content" => "updated file contents"
          },
          "old_name.txt" => {
            "filename" => "new_name.txt",
            "content" => "modified contents"
          },
          "new_file.txt" => {
            "content" => "a new file"
          },
          "delete_this_file.txt" => nil
        }
      }
    }

    context "resouce edited" do
      before do
        stub_patch("/gists/#{gist_id}").
          with(inputs).
          to_return(:body => fixture('gists/gist.json'),
            :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should edit resource successfully" do
        github.gists.edit gist_id, inputs
        a_patch("/gists/#{gist_id}").with(inputs).should have_been_made
      end

      it "should return the resource" do
        gist = github.gists.edit gist_id, inputs
        gist.should be_a Hashie::Mash
      end

      it "should get the gist information" do
        gist = github.gists.edit gist_id, inputs
        gist.user.login.should == 'octocat'
      end
    end

    context "failed to edit resource" do
      before do
        stub_patch("/gists/#{gist_id}").with(inputs).
          to_return(:body => fixture('gists/gist.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrieve resource" do
        expect {
          github.gists.edit gist_id, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # edit

  context '#star' do
    before do
      stub_put("/gists/#{gist_id}/star").
        to_return(:body => '',
              :status => 204,
              :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should raise error if gist id not present" do
      expect {
        github.gists.star nil
      }.to raise_error(ArgumentError)
    end

    it 'successfully stars a gist' do
      github.gists.star gist_id
      a_put("/gists/#{gist_id}/star").should have_been_made
    end

    it "should return 204 with a message 'Not Found'" do
      github.gists.star(gist_id).status.should be 204
    end
  end # star

  context '#unstar' do
    before do
      stub_delete("/gists/#{gist_id}/star").
        to_return(:body => '',
              :status => 204,
              :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should raise error if gist id not present" do
      expect {
        github.gists.unstar nil
      }.to raise_error(ArgumentError)
    end

    it 'successfully stars a gist' do
      github.gists.unstar gist_id
      a_delete("/gists/#{gist_id}/star").should have_been_made
    end

    it "should return 204 with a message 'Not Found'" do
      github.gists.unstar(gist_id).status.should be 204
    end
  end # unstar

  context '#starred?' do
    before do
      stub_get("/gists/#{gist_id}/star").
        to_return(:body => '',
              :status => 204,
              :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it 'should raise error if gist id not present' do
      expect {
        github.gists.starred? nil
      }.to raise_error(ArgumentError)
    end

    it 'should perform request' do
      github.gists.starred? gist_id
      a_get("/gists/#{gist_id}/star").should have_been_made
    end

    it 'should return true if gist is already starred' do
      github.gists.starred?(gist_id).should be_true
    end

    it 'should return false if gist is not starred' do
      stub_get("/gists/#{gist_id}/star").
        to_return(:body => '',
              :status => 404,
              :headers => {:content_type => "application/json; charset=utf-8"})
      github.gists.starred?(gist_id).should be_false
    end
  end # starred?

  context '#fork' do
    before do
      stub_post("/gists/#{gist_id}/fork").
        to_return(:body => fixture('gists/gist.json'),
              :status => 201,
              :headers => {:content_type => "application/json; charset=utf-8"})
    end


    it "should fail to fork gist without gist id" do
      expect { github.gists.fork(nil) }.to raise_error(ArgumentError)
    end

    it "should fork resource successfully" do
      github.gists.fork gist_id
      a_post("/gists/#{gist_id}/fork").should have_been_made
    end

    it "should return the resource" do
      gist = github.gists.fork gist_id
      gist.should be_a Hashie::Mash
    end

    it "should get the gist information" do
      gist = github.gists.fork gist_id
      gist.user.login.should == 'octocat'
    end

    it 'fails to retrieve resource' do
      stub_post("/gists/#{gist_id}/fork").
        to_return(:body => '',
          :status => 404,
          :headers => {:content_type => "application/json; charset=utf-8"})
      expect {
        github.gists.fork gist_id
      }.to raise_error(Github::Error::NotFound)
    end
  end # fork

  context "#delete" do
    before do
      stub_delete("/gists/#{gist_id}").
        to_return(:body => fixture('gists/gist.json'),
              :status => 204,
              :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it 'should raise error if gist id not present' do
      expect {
        github.gists.delete nil
      }.to raise_error(ArgumentError)
    end

    it "should remove resource successfully" do
      github.gists.delete gist_id
      a_delete("/gists/#{gist_id}").should have_been_made
    end

    it "fails to delete resource" do
      stub_delete("/gists/#{gist_id}").
        to_return(:body => '',
          :status => 404,
          :headers => {:content_type => "application/json; charset=utf-8"})
      expect {
        github.gists.delete gist_id
      }.to raise_error(Github::Error::NotFound)
    end
  end # delete

end # Github::Gists
