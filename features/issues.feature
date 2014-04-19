Feature: Issues API

  Background:
    Given I have "Github::Client::Issues" instance

  Scenario: List

    Given I want to list resources
      And I pass the following request options:
        | filter  | state | sort | direction |
        | created | open | created | asc |
    When I make request within a cassette named "issues/list/user"
    Then the response status should be 200
      And the response type should be JSON

  Scenario: List on repository

    Given I want to list resources with the following params:
      | user          | repo   |
      | peter-murach  | github |
    And I pass the following request options:
      | state  | assignee | sort    | direction | user         | repo   |
      | closed | none     | created | asc       | peter-murach | github |
    When I make request within a cassette named "issues/list/repo"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Get single

    Given I want to get resource with the following params:
      | user          | repo   | issue_id |
      | peter-murach  | github | 15       |
    When I make request within a cassette named "issues/get"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Create

    Given I want to create resource with the following params:
      | user  | repo            |
      | murek | github_api_test |
    And I pass the following request options:
      | title       | body                | assignee |
      | Found a bug | Im having a problem | murek    |
    When I make request within a cassette named "issues/create"
    Then the response status should be 201
      And the response type should be JSON
      And the response should not be empty

  Scenario: Edit

    Given I want to edit resource with the following params:
      | user  | repo            | issue_id |
      | murek | github_api_test | 1        |
    And I pass the following request options:
      | body                          |
      | Im having a problem with this |
    When I make request within a cassette named "issues/edit"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

