Feature: Commits API

  Background:
    Given I have "Github::Client::Repos::Commits" instance

  Scenario: List

    Given I want to list resources with the following params:
      | user         | repo           |
      | peter-murach | finite_machine |
    When I make request within a cassette named "repos/commits/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Get

    Given I want get resource with the following params:
      | user         | repo           | sha                                      |
      | peter-murach | finite_machine | 0755d7f473b76c691044cc2e57b60986f81fbb9a |
    When I make request within a cassette named "repos/commits/get"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Compare

    Given I want compare resource with the following params:
      | user         | repo   | base   | head    |
      | peter-murach | github | master | new_dsl |
    When I make request within a cassette named "repos/commits/compare"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

