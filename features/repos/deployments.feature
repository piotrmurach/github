Feature: Deployments API

  Background:
    Given I have "Github::Client::Repos::Deployments" instance

  Scenario: List

    Given I want to list resources with the following params:
      | user  | repo            |
      | murek | github_api_test |
    When I make request within a cassette named "repos/deployments/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Create

    Given I want to create resource with the following params:
      | owner | repo            |
      | murek | github_api_test |
      And I pass the following request options:
        | ref    |
        | master |
    When I make request within a cassette named "repos/deployments/create"
    Then the response status should be 201
      And the response type should be JSON
      And the response should not be empty

  Scenario: Create status

    Given I want to create_status resource with the following params:
      | owner | repo            | id    |
      | murek | github_api_test | 24401 |
      And I pass the following request options:
        | state   |
        | success |
    When I make request within a cassette named "repos/deployments/create_status"
    Then the response status should be 201
      And the response type should be JSON
      And the response should not be empty

  Scenario: List statuses

    Given I want to statuses resource with the following params:
      | user  | repo            | id    |
      | murek | github_api_test | 24401 |
    When I make request within a cassette named "repos/deployments/list_statuses"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty
