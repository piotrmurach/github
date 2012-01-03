Before do
  step "I have github instance"
end

When /^(.*) within a cassette named "([^"]*)"$/ do |step_to_call, cassette_name|
  VCR.use_cassette(cassette_name) { step step_to_call }
end

Then /^the response should be "([^"]*)"$/ do |expected_response|
  @response.status.should eql expected_response.to_i
end
