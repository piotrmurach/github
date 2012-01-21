Given /^I have github instance$/ do
  @github = Github.new
end

Given /^I have "([^"]*)" instance$/ do |api_classes|
  constant = Object
  api_classes.split('::').each do |api_class|
    constant = constant.const_get api_class
  end
  @instance = constant.new
end

When /^I fetch "([^"]*)"$/ do |method|
  @response = @github.send(method.to_sym)
end

When /^I will have access to "([^"]*)" API$/ do |api|
  @response.class.to_s.should match api
end

When /^I am looking for "([^"]*)"$/ do |method|
  @method = method
end

When /^I pass the following request options:$/ do |table|
  table.hashes.each do |options|
    @options = options
  end
end

When /^I am looking for "([^"]*)" with the following params:$/ do |method, table|
  table.hashes.each do |attributes|
    @method = method.to_sym
    @attributes = attributes
  end
end

When /^I make request$/ do
  @options ||= {}
  @attributes ||= {}
  @response = @instance.send @method, *@attributes.values, @options
end

When /^I request "([^"]*)" page$/ do |link|
  @next_response = @response.send :"#{link}_page"
end

Then /^the response collection of resources is different for "([^"]*)" attribute$/ do |attr|
  @next_response.first.send(:"#{attr}").should_not eql @response.first.send(:"#{attr}")
end
