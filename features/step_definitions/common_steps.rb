Before do
  step "I have github instance"
end

When /^(.*) within a cassette named "([^"]*)"$/ do |step_to_call, cassette_name|
  VCR.use_cassette(cassette_name) { step step_to_call }
end

When /^(.*) within a cassette named "([^"]*)" and match on (.*)$/ do |step_to_call, cassette_name, matchers|
  matches = matchers.split(',').map { |m| m.gsub(/\s*/,'') }.map(&:to_sym)
  VCR.use_cassette(cassette_name, :match_requests_on => matches) { step step_to_call }
end

Then /^the response should equal (.*)$/ do |expected_response|
  expected = case expected_response
  when /t/
    true
  when /f/
    false
  else
    raise ArgumentError 'Expected boolean type!'
  end
  @response.should == expected
end

Then /^the response status should be (.*)$/ do |expected_response|
  @response.status.should eql expected_response.to_i
end

Then /^the response should be (.*)$/ do |expected_response|
  expected_response = case expected_response
  when /false/
    @response.should be_false
  when /true/
    @response.should be_true
  when /\d+/
    @response.should eql expected_response.to_i
  when /empty/
    @response.should be_empty
  else
    @response.should eql expected_response
  end
end

Then /^the response type should be (.*)$/ do |type|
  case type.downcase
  when 'json'
    @response.headers.content_type.should =~ /application\/json/
  when 'html'
    @response.headers.content_type.should =~ /text\/html/
  when 'raw'
    @response.headers.content_type.should =~ /raw/
  end
end

Then /^the response should have (\d+) items$/ do |size|
  @response.size.should eql size.to_i
end

Then /^the response should not be empty$/ do
  @response.should_not be_empty
end

Then /^the response should in (.*) contain (.*)$/ do |attr, item|
  case @response.body
  when Array
    found = nil
    @response.body.each do |element|
      found = element[attr] if element[attr] == item
    end
    expect(found).to eql(item)
  end
end

Then /^the response should contain (.*)$/ do |item|
  case @response.body
  when Array
    @response.body.should include item
  end
end

Then /^the response should contain:$/ do |string|
  expect(@response.body.strip).to eql(string.strip)
end

Then /^the response (.*) link should contain:$/ do |type, table|
  table.hashes.each do |attributes|
    attributes.each do |key, val|
      @response.links.send(:"#{type}").should match /#{key}=#{val}/
    end
  end
end

Then /^the response body (.*) should be (.*)$/ do |attr, result|
  expect(@response.body[attr]).to eql result
end

Then /^the response (.*) item (.*) should be (.*)$/ do |action, field, result|
  if action == 'first'
    @response.first.send(field).should eql result
  else
    @response.last.send(field).should eql result
  end
end
