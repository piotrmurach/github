Feature: Organizations API

  Background:
    Given I have "Github::Client::Orgs" instance

  Scenario: List for the user

    Given I want to list resources
      And I pass the following request options:
        | user   |
        | wycats |
    When I make request within a cassette named "orgs/list/user"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: List for the authenticated user

    Given I want to list resources
    When I make request within a cassette named "orgs/list/oauth_user"
    Then the response status should be 200
      And the response type should be JSON

  Scenario: Get

    Given I want to get resource with the following params:
      | org_name |
      | github   |
    When I make request within a cassette named "orgs/get"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty
