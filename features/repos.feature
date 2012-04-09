Feature: Accessing Repos Main API
  In order to interact with github repositories
  GithubAPI gem
  Should return the expected results depending on passed parameters

  Background:
    Given I have "Github::Repos" instance

  Scenario: Returning all repository branches
    When I am looking for "branches" with the following params:
      | user          | repo   |
      | peter-murach  | github |
      And I make request within a cassette named "repos/branches"
    Then the response should be "200"
      And the response type should be "JSON"

  Scenario: Returning all repository tags
    When I am looking for "tags" with the following params:
      | user          | repo   |
      | peter-murach  | github |
      And I make request within a cassette named "repos/tags"
    Then the response should be "200"
      And the response type should be "JSON"

  Scenario: Returning all repositories for the user
    When I want to list resources
      And I pass the following request options:
        | user          |
        | peter-murach  |
      And I make request within a cassette named "repos/list"
    Then the response should be "200"
      And the response type should be "JSON"
