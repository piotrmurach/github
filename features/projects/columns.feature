Feature: Projects Columns API

  Background:
    Given I have "Github::Client::Projects::Columns" instance

  Scenario: List

    Given I want to list resource with the following params:
      | project_id |
      | 524103     |
    When I make request within a cassette named "projects/columns/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Get

    Given I want to get resource with the following params:
      | column_id |
      | 887705    |
    When I make request within a cassette named "projects/columns/get"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Create

    Given I want to create resource with the following params:
      | project_id |
      | 524103     |
    And I pass the following request options:
      | name                   |
      | New column             |
    When I make request within a cassette named "projects/columns/create"
    Then the response status should be 201
      And the response type should be JSON
      And the response should not be empty

  Scenario: Update

    Given I want to update resource with the following params:
      | column_id |
      | 887705    |
    And I pass the following request options:
      | name                   |
      | To Do                  |
    When I make request within a cassette named "projects/columns/update"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Move

    Given I want to move resource with the following params:
      | column_id |
      | 887706    |
    And I pass the following request options:
      | position            |
      | after:887708        |
    When I make request within a cassette named "projects/columns/move"
    Then the response status should be 201
      And the response type should be JSON
      And the response should be empty

  Scenario: Delete

    Given I want to delete resource with the following params:
      | column_id |
      | 895044    |
    When I make request within a cassette named "projects/columns/delete"
    Then the response status should be 204
      And the response should be empty
