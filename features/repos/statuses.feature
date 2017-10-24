Feature: Statuses API

  Background:
    Given I have "Github::Client::Repos::Statuses" instance

  Scenario: List

    Given I want to list resources with the following params:
      | user         | repo   | sha                                      |
      | peter-murach | github | cbdc6a5b133bf460d9c18292dda8fc54adf7e1b1 |
    When I make request within a cassette named "repos/statuses/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: List combined

    Given I want to list resources with the following params:
      | user         | repo   | sha                                      |
      | peter-murach | github | cbdc6a5b133bf460d9c18292dda8fc54adf7e1b1 |
      And I pass the following request options:
        | combined |
        | true     |
    When I make request within a cassette named "repos/statuses/list_combined"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

#   Scenario: Create
# 
#     Given I want to create resource with the following params:
#       | user  | repo            | sha                                      |
#       | murek | github_api_test | 0106b45311ab15bf837c2830391b01cd17b33b61 |
#       And I pass the following request options:
#       | state   | target_url                         | description        |
#       | success | http://ci.example.com/peter-murach | Test by github_api |
#     When I make request within a cassette named "repos/statuses/create"
#     Then the response status should be 201
#       And the response type should be JSON
#       And the response should not be empty
