Feature: Release Assets API

  Background:
    Given I have "Github::Client::Repos::Releases::Assets" instance
    And I do not verify ssl

  Scenario: List

    Given I want to list resources with the following params:
      | owner   | repo                     | id    |
      | ase-lab | CocoaLumberjackFramework | 83441 |
    When I make request within a cassette named "repos/assets/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Get

    Given I want to get resource with the following params:
      | owner   | repo                     | id    |
      | ase-lab | CocoaLumberjackFramework | 33546 |
    When I make request within a cassette named "repos/assets/get"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Upload

    Given I want to upload resource with the following params:
      | owner | repo            | id    | filepath |
      | murek | github_api_test | 54999 | Rakefile |
      And I pass the following request options:
        | name     |
        | Rakefile |
    When I make request within a cassette named "repos/assets/upload"
    Then the response status should be 201
      And the response type should be JSON
      And the response should not be empty

  Scenario: Edit

    Given I want to edit resource with the following params:
      | owner | repo            | id    |
      | murek | github_api_test | 46084 |
      And I pass the following request options:
        | name | label     |
        | Rake | Ruby code |
    When I make request within a cassette named "repos/assets/edit"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Delete

    Given I want to delete resource with the following params:
      | owner | repo            | id    |
      | murek | github_api_test | 118934|
    When I make request within a cassette named "repos/assets/delete"
    Then the response status should be 204
