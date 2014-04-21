Feature: Releases API

  Background:
    Given I have "Github::Client::Repos::Releases" instance

  Scenario: List

    Given I want to list resources with the following params:
      | owner   | repo                     |
      | ase-lab | CocoaLumberjackFramework |
    When I make request within a cassette named "repos/releases/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Get

    Given I want to get resource with the following params:
      | owner   | repo                     | id    |
      | ase-lab | CocoaLumberjackFramework | 16963 |
    When I make request within a cassette named "repos/releases/get"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Create

    Given I want to create resource with the following params:
      | owner | repo            | tag_name |
      | murek | github_api_test | v1.0.0   |
      And I pass the following request options:
        | name   | body         | draft | target_commitish |
        | v1.0.0 | Main release | false | master           |
    When I make request within a cassette named "repos/releases/create"
    Then the response status should be 201
      And the response type should be JSON
      And the response should not be empty

  Scenario: Edit

    Given I want to edit resource with the following params:
      | owner | repo            | id    |
      | murek | github_api_test | 54999 |
      And I pass the following request options:
        | name   | body         | draft | target_commitish |
        | v1.0.0 | Main release | false | master           |
    When I make request within a cassette named "repos/releases/edit"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Delete

    Given I want to delete resource with the following params:
      | owner | repo            | id     |
      | murek | github_api_test | 281255 |
    When I make request within a cassette named "repos/releases/delete"
    Then the response status should be 204
