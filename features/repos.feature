Feature: Accessing Repos Main API
  In order to interact with github repositories
  GithubAPI gem
  Should return the expected results depending on passed parameters

  Scenario: Returning all repository branches
    Given I have "Github::Repos" instance
    And I am looking for "branches" with the following params:
      | user          | repo   |
      | peter-murach  | github |
    And I make request within a cassette named "repos/branches"
    Then the response should be "200"

  Scenario: Returning all repository tags
    Given I have "Github::Repos" instance
    And I am looking for "tags" with the following params:
      | user          | repo   |
      | peter-murach  | github |
    And I make request within a cassette named "repos/tags"
    Then the response should be "200"

  Scenario: Returning all repositories for the user
    Given I have "Github::Repos" instance
    And I am looking for "list_repos" with the following params:
      | user          |
      | peter-murach  |
    And I make request with hash params within a cassette named "repos/tags"
    Then the response should be "200"
