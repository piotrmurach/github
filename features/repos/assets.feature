Feature: Release Assets API

  Background:
    Given I have "Github::Repos::Releases::Assets" instance

  Scenario: List

    Given I want to list resources with the following params:
      | owner   | repo   | id |
      | ase-lab | CocoaLumberjackFramework | 83441 |
    When I make request within a cassette named "repos/assets/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Get

    Given I want to get resource with the following params:
      | owner   | repo   | id |
      | ase-lab | CocoaLumberjackFramework | 33546 |
    When I make request within a cassette named "repos/assets/get"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty
