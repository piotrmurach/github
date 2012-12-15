Feature: Labels API

  Background:
    Given I have "Github::Issues::Labels" instance

  Scenario: List in a repository

    Given I want to list resources with the following params:
      | user         | repo   |
      | peter-murach | github |
    When I make request within a cassette named "issues/labels/list_repo"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty
