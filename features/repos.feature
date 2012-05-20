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
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Returning all repository tags
    When I am looking for "tags" with the following params:
      | user          | repo   |
      | peter-murach  | github |
      And I make request within a cassette named "repos/tags"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Returning all repositories for the user
    Given I want to list resources
      And I pass the following request options:
        | user          |
        | peter-murach  |
    When I make request within a cassette named "repos/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Get a repository
    Given I want to get resource with the following params:
      | user   | repo |
      | wycats | thor |
    When I make request within a cassette named "repos/get"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Listing repository languages
    When I am looking for "languages" with the following params:
      | user          | repo   |
      | peter-murach  | github |
      And I make request within a cassette named "repos/languages"
    Then the response status should be 200
      And the response type should be JSON

  Scenario: Create repository
    Given I want to create resource
      And I pass the following request options:
        | name            |
        | github_api_test |
    When I make request within a cassette named "repos/create"
    Then the response status should be 201
      And the response type should be JSON
      And the response should not be empty
