Feature: Users API

  Background:
    Given I have "Github::Client::Users" instance

  Scenario: List all users

    Given I want to list resources
    When I make request within a cassette named "users/all"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Get authenticated user

    Given I want to get resource
    When I make request within a cassette named "users/get/oauth"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Get unauthenticated user

    Given I want to get resource
    And I pass the following request options:
      | user         |
      | peter-murach |
    When I make request within a cassette named "users/get/user"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty
