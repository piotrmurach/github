Given /^I have github instance$/ do
  @github = Github.new
end

When /^I fetch "([^"]*)"$/ do |method|
  @response = @github.send(method.to_sym)
end

When /^I will have access to "([^"]*)" API$/ do |api|
  @response.class.to_s.should match api
end
