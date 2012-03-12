require 'spec_helper'

describe Github::Users::Emails do
  let(:github) { Github.new }
  let(:email) { "octocat@github.com" }

  before { github.oauth_token = OAUTH_TOKEN }
  after { reset_authentication_for github }

  describe "#emails" do
    context "resource found for an authenticated user" do
      before do
        stub_get("/user/emails").
          with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
          to_return(:body => fixture('users/emails.json'),
            :status => 200,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the resources" do
        github.users.emails
        a_get("/user/emails").
          with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
          should have_been_made
      end

      it "should return resource" do
        emails = github.users.emails
        emails.should be_an Array
        emails.should have(2).items
      end

      it "should get emails information" do
        emails = github.users.emails
        emails.first.should == email
      end

      it "should yield to a block" do
        github.users.should_receive(:emails).and_yield('web')
        github.users.emails { |param| 'web' }
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
          github.users.emails
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # emails

  context '#add_email' do
    let(:params) { { :per_page => 21, :page => 1 }}

    before do
      stub_post("/user/emails").
        with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
        to_return(:body => fixture('users/emails.json'),
          :status => 200,
          :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it 'extracts request parameters and email data' do
      github.users.should_receive(:post).
        with("/user/emails", { "per_page" => 21, "page" => 1, "data" => [email] })
      github.users.add_email email, params
    end

    it 'submits request successfully' do
      github.users.add_email email
      a_post("/user/emails").
        with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
        should have_been_made
    end
  end # add_email

  context '#delete_email' do
    let(:params) { { :per_page => 21, :page => 1 }}

    before do
      stub_delete("/user/emails").
        with(:query => { :access_token => "#{OAUTH_TOKEN}", :data => email}).
        to_return(:body => fixture('users/emails.json'),
          :status => 200,
          :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it 'extracts request parameters and email data' do
      github.users.should_receive(:delete).
        with("/user/emails", { "per_page" => 21, "page" => 1, "data" => [email] })
      github.users.delete_email email, params
    end

    it 'submits request successfully' do
      github.users.delete_email email
      a_delete("/user/emails").
        with(:query => { :access_token => "#{OAUTH_TOKEN}", :data => email } ).
        should have_been_made
    end
  end # delete_email

end # Github::Users::Emails
