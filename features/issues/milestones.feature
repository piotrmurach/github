Feature: Milestones API

  Background:
    Given I have "Github::Client::Issues::Milestones" instance

  Scenario: List

    Given I want to list resources with the following params:
      | user         | repo   |
      | peter-murach | github |
    When I make request within a cassette named "issues/milestones/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should be empty

  Scenario: Get a single milestone

    Given I want to get resource with the following params:
      | user | repo            | number |
      | josh | rails-behaviors | 1      |
    And I pass the following request options:
      | state  |
      | closed |
    When I make request within a cassette named "issues/milestones/get"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Create

    Given I want to create resource with the following params:
      | user  | repo            |
      | murek | github_api_test |
    And I pass the following request options:
      | title   | state | description       |
      | fix-all | open  | fixing all issues |
    When I make request within a cassette named "issues/milestones/create" and match on method
    Then the response status should be 201
      And the response type should be JSON
      And the response should not be empty

  Scenario: Update

    Given I want to update resource with the following params:
      | user  | repo            | number |
      | murek | github_api_test | 1      |
    And I pass the following request options:
      | state  |
      | closed |
    When I make request within a cassette named "issues/milestones/update" and match on method
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Delete

    Given I want to delete resource with the following params:
      | user  | repo            | number |
      | murek | github_api_test | 1      |
    When I make request within a cassette named "issues/milestones/delete" and match on method
    Then the response status should be 204

