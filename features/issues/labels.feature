Feature: Labels API

  Background:
    Given I have "Github::Issues::Labels" instance

  Scenario: List in a repository

    Given I want to list resources with the following params:
      | user         | repo   |
      | peter-murach | github |
    When I make request within a cassette named "issues/labels/list_repo"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: List in a milestone

    Given I want to list resources with the following params:
      | user         | repo   |
      | plataformatec| devise |
    And I pass the following request options:
      | milestone_id |
      | 3            |
    When I make request within a cassette named "issues/labels/list_milestone"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: List in an issue

    Given I want to list resources with the following params:
      | user         | repo   |
      | plataformatec| devise |
    And I pass the following request options:
      | issue_id |
      | 1944     |
    When I make request within a cassette named "issues/labels/list_issue"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Get

    Given I want to get resource with the following params:
      | user         | repo   | label_name |
      | peter-murach | github | bug        |
    When I make request within a cassette named "issues/labels/get"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Create

    Given I want to create resource with the following params:
      | user  | repo            |
      | murek | github_api_test |
    And I pass the following request options:
      | name | color  |
      | api  | FFFFFF |
    When I make request within a cassette named "issues/labels/create" and match on method
    Then the response status should be 201
      And the response type should be JSON
      And the response should not be empty

  Scenario: Update

    Given I want to update resource with the following params:
      | user  | repo            | label_name |
      | murek | github_api_test | api        |
    And I pass the following request options:
      | name | color  |
      | api  | 000000 |
    When I make request within a cassette named "issues/labels/update" and match on method
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Delete

    Given I want to delete resource with the following params:
      | user  | repo            | label_name |
      | murek | github_api_test | api        |
    When I make request within a cassette named "issues/labels/delete" and match on method
    Then the response status should be 204

