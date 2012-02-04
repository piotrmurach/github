require 'spec_helper'

describe Github::Gists, :type => :base do

  describe "#gists" do
    context 'check aliases' do
      it { github.gists.should respond_to :gists }
      it { github.gists.should respond_to :list_gists }
    end

    context "- unauthenticated user" do
      context "resource found" do
        before do
          stub_get("/users/#{user}/gists").
            to_return(:body => fixture('gists/gists.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
        end

        it "should get the resources" do
          github.gists.gists user
          a_get("/users/#{user}/gists").should have_been_made
        end

        it "should return array of resources" do
          gists = github.gists.gists user
          gists.should be_an Array
          gists.should have(1).items
        end

        it "should be a mash type" do
          gists = github.gists.gists user
          gists.first.should be_a Hashie::Mash
        end

        it "should get gist information" do
          gists = github.gists.gists user
          gists.first.user.login.should == 'octocat'
        end

        it "should yield to a block" do
          github.gists.should_receive(:gists).with(user).and_yield('web')
          github.gists.gists(user) { |param| 'web' }
        end
      end

      context "resource not found" do
        before do
          stub_get("/users/#{user}/gists").
            to_return(:body => "", :status => [404, "Not Found"])
        end

        it "should return 404 with a message 'Not Found'" do
          expect {
            github.gists.gists user
          }.to raise_error(Github::ResourceNotFound)
        end
      end
    end # unauthenticated user

    context '- public' do
      before do
        github.user = nil
        stub_get("/gists/public").
          to_return(:body => fixture('gists/gists.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the resources" do
        github.gists.gists
        a_get("/gists/public").should have_been_made
      end
    end

    context '- authenticated user' do
      before do
        github.user = nil
        github.oauth_token = OAUTH_TOKEN
        stub_get("/gists").
          with(:query => {:access_token => OAUTH_TOKEN}).
          to_return(:body => fixture('gists/gists.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end
      after do
        github.oauth_token = nil
      end

      it "should get the resources" do
        github.gists.gists
        a_get("/gists").with(:query => {:access_token => OAUTH_TOKEN}).
          should have_been_made
      end
    end
  end # gists

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
        }.to raise_error(Github::ResourceNotFound)
      end
    end

  end # starred

  describe "#gist" do
    let(:gist_id) { '1' }

    context 'check aliases' do
      it { github.gists.should respond_to :gist }
      it { github.gists.should respond_to :get_gist }
    end

    context "resource found" do
      before do
        stub_get("/gists/#{gist_id}").
          to_return(:body => fixture('gists/gist.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without gist id" do
        expect { github.gists.gist(nil)}.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.gists.gist gist_id
        a_get("/gists/#{gist_id}").should have_been_made
      end

      it "should get gist information" do
        gist = github.gists.gist gist_id
        gist.id.should eq gist_id
        gist.user.login.should == 'octocat'
      end

      it "should return mash" do
        gist = github.gists.gist gist_id
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
          github.gists.gist gist_id
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # gist

end # Github::Gists
