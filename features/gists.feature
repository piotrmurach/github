Feature: Gists API

  Background:
    Given I have "Github::Gists" instance

  Scenario: List all user's gists

    Given I want to list resources
      And I pass the following request options:
        | user          |
        | peter-murach  |
    When I make request within a cassette named "gists/gists/user_all"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: List public gists

    Given I want to list resources with the following params:
      | public |
      | public |
    When I make request within a cassette named "gists/gists/public_all"
    Then the response status should be 200
      And the response type should be JSON

  Scenario: List starred gists

    Given I want starred resources
    When I make request within a cassette named "gists/gists/starred"
    Then the response status should be 200
      And the response type should be JSON

  Scenario: Gets a single gist

    Given I want to get resource with the following params:
      | gist_id |
      | 1738161 |
    When I make request within a cassette named "gists/gist"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Check if gist is starred

    Given I want to starred? resource with the following params:
      | gist_id |
      | 1738161 |
    When I make request within a cassette named "gists/starred"
    Then the response should equal false

  Scenario: Start gist

    Given I want to star resource with the following params:
      | gist_id |
      | 2900588 |
    When I make request within a cassette named "gists/star"
    Then the response status should be 204

  Scenario: Unstart gist

    Given I want to unstar resource with the following params:
      | gist_id |
      | 2900588 |
    When I make request within a cassette named "gists/unstar"
    Then the response status should be 204

  Scenario: Fork gist

    Given I want to fork resource with the following params:
      | gist_id |
      | 2900588 |
    When I make request within a cassette named "gists/fork"
    Then the response status should be 201
      And the response type should be JSON
      And the response should not be empty

