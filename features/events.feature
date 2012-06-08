Feature: Events API

  Background:
    Given I have "Github::Events" instance

  Scenario: Public

    Given I want public resources
    When I make request within a cassette named "events/public"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Repository

    Given I want repository resources with the following params:
      | user   | repo |
      | wycats | thor |
    When I make request within a cassette named "events/repo"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Issue

    Given I want issue resources with the following params:
      | user   | repo |
      | wycats | thor |
    When I make request within a cassette named "events/issue"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Network

    Given I want network resources with the following params:
      | user   | repo |
      | wycats | thor |
    When I make request within a cassette named "events/network"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Organization

    Given I want org resources with the following params:
      | org   |
      | rails |
    When I make request within a cassette named "events/org"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Received

    Given I want received resources with the following params:
      | user      |
      | josevalim |
    When I make request within a cassette named "events/received"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Performed

    Given I want performed resources with the following params:
      | user      |
      | josevalim |
    When I make request within a cassette named "events/performed"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

