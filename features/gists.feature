Feature: Accessing Gists Main API
  In order to interact with github gists
  GithubAPI gem
  Should return the expected results depending on passed parameters

  Background:
    Given I have "Github::Gists" instance

  Scenario: Lists all user's gists
    Given I want to list resources
      And I pass the following request options:
        | user          |
        | peter-murach  |
    When I make request within a cassette named "gists/gists/user_all"
    Then the response should be "200"
      And the response type should be "JSON"

  Scenario: Lists all public gists
    Given I want to list resources
    When I make request within a cassette named "gists/gists/public_all"
    Then the response should be "200"
      And the response type should be "JSON"

  Scenario: Gets a single gist
    Given I want to get resource with the following params:
      | gist_id |
      | 1738161 |
    When I make request within a cassette named "gists/gist"
    Then the response should be "200"
      And the response type should be "JSON"

  Scenario: Check if gist is starred
    Given I want to starred? resource with the following params:
      | gist_id |
      | 1738161 |
    When I make request within a cassette named "gists/starred"
    Then the response should equal false
