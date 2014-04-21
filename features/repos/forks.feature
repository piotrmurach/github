Feature: Forks API

  Background:
    Given I have "Github::Client::Repos::Forks" instance

  Scenario: List

    Given I want to list resources with the following params:
      | user         | repo   |
      | peter-murach | github |
    When I make request within a cassette named "repos/forks/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: List with sort

    Given I want to list resources with the following params:
      | user         | repo   |
      | peter-murach | github |
    And I pass the following request options:
      | sort   |
      | oldest |
    When I make request within a cassette named "repos/forks/list_sort"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty
      And the response first item created_at should be 2011-12-16T17:06:03Z
