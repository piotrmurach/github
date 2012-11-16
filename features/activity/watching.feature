Feature: Watching API

  Background:
    Given I have "Github::Activity::Watching" instance

  Scenario: List

    Given I want to list resources with the following params:
      | user         | repo   |
      | peter-murach | github |
    When I make request within a cassette named "activity/watching/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Watched

    Given I want to watched resources
      And I pass the following request options:
      | user   |
      | wycats |
    When I make request within a cassette named "activity/watching/watched"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Watching

    Given I want to watching? resource with the following params:
      | user         | repo   |
      | peter-murach | github |
    When I make request within a cassette named "activity/watching/watching"
    Then the response should be false

  Scenario: Watch

    Given I want to watch resource with the following params:
      | user         | repo   |
      | peter-murach | github |
    When I make request within a cassette named "activity/watching/watch"
    Then the response status should be 204

  Scenario: Unwatch

    Given I want to unwatch resource with the following params:
      | user         | repo   |
      | peter-murach | github |
    When I make request within a cassette named "activity/watching/unwatch"
    Then the response status should be 204

