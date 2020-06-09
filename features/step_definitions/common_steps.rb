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
  expect(@response).to eq expected
end

Then /^the response status should be (.*)$/ do |expected_response|
  expect(@response.status).to eql expected_response.to_i
end

Then /^the response should be (.*)$/ do |expected_response|
  expected_response = case expected_response
  when /false/
    expect(@response).to be false
  when /true/
    expect(@response).to be true
  when /\d+/
    expect(@response).to eql expected_response.to_i
  when /empty/
    expect(@response).to be_empty
  else
    expect(@response).to eql expected_response
  end
end

Then /^the response type should be (.*)$/ do |type|
  case type.downcase
  when 'json'
    expect(@response.headers.content_type).to match /application\/json/
  when 'html'
    expect(@response.headers.content_type).to match /text\/html/
  when 'raw'
    expect(@response.headers.content_type).to match /raw/
  end
end

Then /^the response should have (\d+) items$/ do |size|
  expect(@response.size).to eql size.to_i
end

Then /^the response should not be empty$/ do
  expect(@response).to_not be_empty
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
    expect(@response.body).to include item
  end
end

Then /^the response should contain:$/ do |string|
  expect(@response.body.strip).to eql(string.strip)
end

Then /^the response (.*) link should contain:$/ do |type, table|
  table.hashes.each do |attributes|
    attributes.each do |key, val|
      expect(@response.links.send(:"#{type}")).to match /#{key}=#{val}/
    end
  end
end

Then /^the response body (.*) should be (.*)$/ do |attr, result|
  expect(@response.body[attr]).to eql result
end

Then /^the response (.*) item (.*) should be (.*)$/ do |action, field, result|
  if action == 'first'
    expect(@response.first.send(field)).to eql result
  else
    expect(@response.last.send(field)).to eql result
  end
end
