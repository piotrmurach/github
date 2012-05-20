require 'spec_helper'

describe Github::Users::Emails do
  let(:github) { Github.new }
  let(:email) { "octocat@github.com" }

  before { github.oauth_token = OAUTH_TOKEN }
  after { reset_authentication_for github }

  describe "#list" do
    it { github.users.emails.should respond_to :all }

    context "resource found for an authenticated user" do
      before do
        stub_get("/user/emails").
          with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
          to_return(:body => fixture('users/emails.json'),
            :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the resources" do
        github.users.emails.list
        a_get("/user/emails").
          with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
          should have_been_made
      end

      it "should return resource" do
        emails = github.users.emails.list
        emails.should be_an Array
        emails.should have(2).items
      end

      it "should get emails information" do
        emails = github.users.emails.list
        emails.first.should == email
      end

      it "should yield to a block" do
        github.users.emails.should_receive(:list).and_yield('web')
        github.users.emails.list { |param| 'web' }
      end
    end

    context "resource not found for a user" do
      before do
        stub_get("/user/emails").
          with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.users.emails.list
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # emails

  context '#add' do
    let(:params) { { :per_page => 21, :page => 1 }}

    before do
      stub_post("/user/emails").
        with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
        to_return(:body => fixture('users/emails.json'),
          :status => 200,
          :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it 'extracts request parameters and email data' do
      github.users.emails.should_receive(:post_request).
        with("/user/emails", { "per_page" => 21, "page" => 1, "data" => [email] })
      github.users.emails.add email, params
    end

    it 'submits request successfully' do
      github.users.emails.add email
      a_post("/user/emails").
        with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
        should have_been_made
    end
  end # add

  context '#delete' do
    let(:params) { { :per_page => 21, :page => 1 }}

    before do
      stub_delete("/user/emails").
        with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
        to_return(:body => fixture('users/emails.json'), :status => 204,
          :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it 'extracts request parameters and email data' do
      github.users.emails.should_receive(:delete_request).
        with("/user/emails", { "per_page" => 21, "page" => 1, 'data' => [email] })
      github.users.emails.delete email, params
    end

    it 'submits request successfully' do
      github.users.emails.delete email
      a_delete("/user/emails").
        with(:query => { :access_token => "#{OAUTH_TOKEN}" } ).
        should have_been_made
    end
  end # delete

end # Github::Users::Emails
