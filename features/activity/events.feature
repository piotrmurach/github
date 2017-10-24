Feature: Events API

  Background:
    Given I have "Github::Client::Activity::Events" instance

  Scenario: Public

    Given I want public resources
    When I make request within a cassette named "activity/events/public"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Repository

    Given I want repository resources with the following params:
      | user         | repo           |
      | peter-murach | finite_machine |
    When I make request within a cassette named "activity/events/repo"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Issue

    Given I want issue resources with the following params:
      | user         | repo           |
      | peter-murach | finite_machine |
    When I make request within a cassette named "activity/events/issue"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Network

    Given I want network resources with the following params:
      | user         | repo           |
      | peter-murach | finite_machine |
    When I make request within a cassette named "activity/events/network"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Organization

    Given I want org resources with the following params:
      | org   |
      | rails |
    When I make request within a cassette named "activity/events/org"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Received

    Given I want received resources with the following params:
      | user      |
      | josevalim |
    When I make request within a cassette named "activity/events/received"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Performed

    Given I want performed resources with the following params:
      | user      |
      | josevalim |
    When I make request within a cassette named "activity/events/performed"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

