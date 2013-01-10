Feature: Issues Comments API

  Background:
    Given I have "Github::Issues::Comments" instance

  Scenario: List in a repository

    Given I want to list resources with the following params:
      | user         | repo   |
      | peter-murach | github |
    When I make request within a cassette named "issues/comments/list_repo"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: List on an issue

    Given I want to list resources with the following params:
      | user         | repo   |
      | peter-murach | github |
      And I pass the following request options:
        | issue_id |
        | 61       |
    When I make request within a cassette named "issues/comments/list_issue"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Get a single comment

    Given I want to get resource with the following params:
      | user         | repo   | comment_id |
      | peter-murach | github | 10321836   |
    When I make request within a cassette named "issues/comments/get"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Create

    Given I want to create resource with the following params:
      | user  | repo            | issue_id |
      | murek | github_api_test | 1        |
    And I pass the following request options:
      | body                                 |
      | No worries this should be fixed now. |
    When I make request within a cassette named "issues/comments/create" and match on method
    Then the response status should be 201
      And the response type should be JSON
      And the response should not be empty

  Scenario: Edit

    Given I want to edit resource with the following params:
      | user  | repo            | comment_id |
      | murek | github_api_test | 11675857   |
    And I pass the following request options:
      | body                                 |
      | No worries this should be fixed now. |
    When I make request within a cassette named "issues/comments/edit" and match on method
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Delete

    Given I want to delete resource with the following params:
      | user  | repo            | comment_id |
      | murek | github_api_test | 11675857   |
    When I make request within a cassette named "issues/comments/delete" and match on method
    Then the response status should be 204

