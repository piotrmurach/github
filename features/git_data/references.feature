Feature: Accessing GitData References API

  In order to interact with github git data references
  GithubAPI gem
  Should return the expected results depending on passed parameters

  Background:
    Given I have "Github::GitData::References" instance

  Scenario: Lists all references on a repository
    Given I want to list resources with the following params:
      | user   | repo |
      | wycats | thor |
    When I make request within a cassette named "git_data/references/all"
    Then the response should be "200"
      And the response type should be "JSON"
      And the response should not be empty

  Scenario: Lists all references on a repository
    Given I want to list resources with the following params:
      | user   | repo |
      | wycats | thor |
    And I pass the following request options:
      | ref  |
      | tags |
    When I make request within a cassette named "git_data/references/all_tags"
    Then the response should be "200"
      And the response type should be "JSON"
      And the response should not be empty

  Scenario: Gets a single git data reference
    Given I want to get resource with the following params:
      | user   | repo | ref            |
      | wycats | thor | heads/gh-pages |
    When I make request within a cassette named "git_data/references/one"
    Then the response should be "200"
      And the response type should be "JSON"
      And the response should not be empty
