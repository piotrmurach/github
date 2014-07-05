Feature: Events API

  Background:
    Given I have "Github::Client::Issues::Events" instance

  Scenario: List for a repository

    Given I want to list resources with the following params:
      | user         | repo   |
      | peter-murach | github |
    When I make request within a cassette named "issues/events/list_repo"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: List for an issue

    Given I want to list resources with the following params:
      | user         | repo   |
      | peter-murach | github |
    And I pass the following request options:
      | issue_number |
      | 61           |
    When I make request within a cassette named "issues/events/list_issue"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Get

    Given I want to get resource with the following params:
      | user         | repo   | id       |
      | peter-murach | github | 29376722 |
    When I make request within a cassette named "issues/events/get"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

