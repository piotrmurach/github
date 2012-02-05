Before do
  step "I have github instance"
end

When /^(.*) within a cassette named "([^"]*)"$/ do |step_to_call, cassette_name|
  VCR.use_cassette(cassette_name) { step step_to_call }
end

Then /^the response should be "([^"]*)"$/ do |expected_response|
  @response.status.should eql expected_response.to_i
end

Then /^the response type should be "([^"]*)"$/ do |type|
  @response.content_type.should =~ /application\/#{type.downcase}/
end

Then /^the response should have (\d+) items$/ do |size|
  @response.size.should eql size.to_i
end

Then /^the response should not be empty$/ do
  @response.should_not be_empty
end
