Feature: Repositories API

  Background:
    Given I have "Github::Repos" instance

  Scenario: Branches

    Given I want branches resource with the following params:
      | user          | repo   |
      | peter-murach  | github |
    When I make request within a cassette named "repos/branches"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Get Branch

    Given I want branch resource with the following params:
      | user          | repo   | branch  |
      | peter-murach  | github | new_dsl |
    When I make request within a cassette named "repos/branch"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Tags

    Given I want tags resource with the following params:
      | user          | repo   |
      | peter-murach  | github |
    When I make request within a cassette named "repos/tags"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: All repositories for the user

    Given I want to list resources
      And I pass the following request options:
        | user          |
        | peter-murach  |
    When I make request within a cassette named "repos/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: All repositories

    Given I want to list resources with the following params:
      | every |
      | every |
    When I make request within a cassette named "repos/list_repos"
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

  Scenario: Languages

    Given I want languages resource with the following params:
      | user          | repo   |
      | peter-murach  | github |
    When I make request within a cassette named "repos/languages"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Create repository

    Given I want to create resource
      And I pass the following request options:
        | name            |
        | github_api_test |
    When I make request within a cassette named "repos/create"
    Then the response status should be 201
      And the response type should be JSON
      And the response should not be empty

