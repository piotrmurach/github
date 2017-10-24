Feature: Assignees API

  Background:
    Given I have "Github::Client::Issues::Assignees" instance

  Scenario: List

    Given I want to list resources with the following params:
      | user         | repo   |
      | peter-murach | github |
    When I make request within a cassette named "issues/assignees/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Check assignee does not belong to repository

    Given I want to check resource with the following params:
      | user         | repo   | assignee |
      | peter-murach | github | wycats   |
    When I make request within a cassette named "issues/assignees/ckeck_not"
    Then the response should be false

  Scenario: Check assignee belongs to repository

    Given I want to check resource with the following params:
      | user         | repo   | assignee     |
      | peter-murach | github | peter-murach |
    When I make request within a cassette named "issues/assignees/ckeck"
    Then the response should be true
