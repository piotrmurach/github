Feature: Starring API

  Background:
    Given I have "Github::Repos::Starring" instance

  Scenario: List

    Given I want to list resources with the following params:
      | user         | repo   |
      | peter-murach | github |
    When I make request within a cassette named "repos/starring/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Starred

    Given I want to starred resources
      And I pass the following request options:
      | user   |
      | wycats |
    When I make request within a cassette named "repos/starring/starred"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Starring

    Given I want to starring? resource with the following params:
      | user         | repo   |
      | peter-murach | github |
    When I make request within a cassette named "repos/starring/starring"
    Then the response should be false

  Scenario: Star

    Given I want to star resource with the following params:
      | user         | repo   |
      | peter-murach | github |
    When I make request within a cassette named "repos/starring/star"
    Then the response status should be 204

  Scenario: Unstar

    Given I want to unstar resource with the following params:
      | user         | repo   |
      | peter-murach | github |
    When I make request within a cassette named "repos/starring/unstar"
    Then the response status should be 204

