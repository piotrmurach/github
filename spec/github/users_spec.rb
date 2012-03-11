require 'spec_helper'

describe Github::Users, :type => :base do

#   before do
#     reset_authentication_for github
#   end
# 
#   after do
#     reset_authentication_for github
#   end
# 
#   describe "get_user" do
#     context "resource found for a user" do
#       before do
#         stub_get("/users/#{user}").
#           to_return(:body => fixture('users/user.json'),
#             :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
#       end
# 
#       it "should get the resources" do
#         github.users.get_user user
#         a_get("/users/#{user}").should have_been_made
#       end
# 
#       it "should return resource" do
#         user_resource = github.users.get_user user
#         user_resource.should be_a Hash
#       end
# 
#       it "should be a mash type" do
#         user_resource = github.users.get_user user
#         user_resource.should be_a Hashie::Mash
#       end
# 
#       it "should get org information" do
#         user_resource = github.users.get_user user
#         user_resource.login.should == 'octocat'
#       end
# 
#       it "should yield to a block" do
#         github.users.should_receive(:get_user).with(user).and_yield('web')
#         github.users.get_user(user) { |param| 'web' }
#       end
#     end
# 
#     context "resource found for an authenticated user" do
#       before do
#         github.oauth_token = OAUTH_TOKEN
#         stub_get("/user").
#           with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
#           to_return(:body => fixture('users/user.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
#       end
# 
#       it "should get the resources" do
#         github.users.get_user
#         a_get("/user").with(:query => {:access_token => "#{OAUTH_TOKEN}"}).
#           should have_been_made
#       end
#     end
# 
#     context "resource not found for a user" do
#       before do
#         stub_get("/users/#{user}").
#           to_return(:body => "", :status => [404, "Not Found"])
#       end
# 
#       it "should return 404 with a message 'Not Found'" do
#         expect {
#           github.users.get_user user
#         }.to raise_error(Github::Error::NotFound)
#       end
#     end
#   end # get_user
# 
#   describe "update_user" do
#     let(:user_params) {
#       {
#         "name" => "monalisa octocat",
#         "email" => "octocat@github.com",
#         "blog" => "https://github.com/blog",
#         "company" => "GitHub",
#         "location" => "San Francisco",
#         "hireable" => true,
#         "bio" => "There once..."
#       }
#     }
# 
#     context "resouce updated" do
#       before do
#         github.oauth_token = OAUTH_TOKEN
#         stub_patch("/user?access_token=#{OAUTH_TOKEN}").with(user_params).
#           to_return(:body => fixture('users/user.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
# 
#       end
# 
#       it "should create resource successfully" do
#         github.users.update_user
#         a_patch("/user?access_token=#{OAUTH_TOKEN}").with(user_params).should have_been_made
#       end
# 
#       it "should return the resource" do
#         user_resource = github.users.update_user
#         user_resource.should be_a Hashie::Mash
#       end
# 
#       it "should get the resource information" do
#         user_resource = github.users.update_user
#         user_resource.login.should == 'octocat'
#       end
#     end
# 
#     context "failed to update resource" do
#       before do
#         github.oauth_token = OAUTH_TOKEN
#         stub_patch("/user?access_token=#{OAUTH_TOKEN}").with(user_params).
#           to_return(:body => fixture('users/user.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
# 
#       end
# 
#       it "should fail to retrieve resource" do
#         expect {
#           github.users.update_user
#         }.to raise_error(Github::Error::NotFound)
#       end
#     end
#   end # update_comment

end # Github::Users
