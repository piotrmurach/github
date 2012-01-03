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

When /^I am looking for "([^"]*)" with the following params:$/ do |method, table|
  table.hashes.each do |attributes|
    @method = method.to_sym
    @attributes = attributes
  end
end

When /^I make request$/ do
  @response = @instance.send @method, *@attributes.values
end

When /^I make request with hash params$/ do
  @response = @instance.send @method, @attributes
end
