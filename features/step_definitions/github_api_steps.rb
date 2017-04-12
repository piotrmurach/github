Given /^I have github instance$/ do
  @github = Github.new(
    :basic_auth  => SETTINGS['basic_auth'],
    :oauth_token => SETTINGS['oauth_token']
  )
end

Given /^I have "([^"]*)" instance$/ do |api_classes|
  @instance = convert_to_constant(api_classes).new(
    :basic_auth  => SETTINGS['basic_auth'],
    :oauth_token => SETTINGS['oauth_token']
  )
end

Given /^I do not verify ssl$/ do
  @instance.ssl = {:verify => false}
end

Given /^I set the following (?:attribute|attributes) of instance:$/ do |table|
  table.hashes.each do |element|
    element.each do |attr, val|
      @instance.send(:"#{attr}=", val)
    end
  end
end

When /^I am not authorized$/ do
  [:basic_auth, :login, :password, :oauth_token].each do |attr|
    @instance.send("#{attr}=", nil)
  end
end

When /^I fetch "([^"]*)"$/ do |method|
  @response = @github.send(method.to_sym)
end

When /^I call (.*)$/ do |api_part|
  @response = @instance.send(api_part.to_sym)
end

When /^I will have access to "([^"]*)" API$/ do |api|
  @response.class.to_s.should match api
end

When /^I want(?: to|) (.*) (?:resource|resources)$/ do |method|
  @method = method
end

When /^I want(?: to|) (.*) (?:resource|resources) with the following (?:params|arguments):$/ do |method, table|
  table.hashes.each do |attributes|
    @method = method.to_sym
    @attributes = attributes
  end
end

When /^I pass the following request options:$/ do |table|
  table.hashes.each do |options|
    options.each do |k, v|
      begin
        options[k] = Integer(v) # Github API requires Integers in data to be sent as literal integers
      rescue ArgumentError
        next
      end
    end
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

When /^I request (.*) page$/ do |link|
  @next_response = @response.send :"#{link}_page"
end

When /^I iterate through collection pages$/ do
  @pages = []
  @response.each_page do |page|
    @pages << page.flatten
  end
end

Then /^the request header (.*) should be$/ do |header, value|
  expect(@response.headers.env[:request_headers][header]).to eql(value)
end

Then /^the response collection of resources is different for "([^"]*)" attribute$/ do |attr|
  @next_response.first.send(:"#{attr}").should_not eql @response.first.send(:"#{attr}")
end

Then /^this collection should include first page$/ do
  @pages.flatten.map(&:name).should include @response.first.name
end

Then /^request should fail with "([^"]*)"$/ do |exception|
  @options ||= {}
  @attributes ||= {}
  expect {
    @response = @instance.send @method, *@attributes.values, @options
  }.to raise_error(convert_to_constant(exception))
end
