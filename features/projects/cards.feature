Feature: Projects Cards API

  Background:
    Given I have "Github::Client::Projects::Cards" instance

  Scenario: List

    Given I want to list resource with the following params:
      | column_id  |
      | 887705     |
    When I make request within a cassette named "projects/columns/cards/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Get

    Given I want to get resource with the following params:
      | card_id |
      | 2422870 |
    When I make request within a cassette named "projects/columns/cards/get"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Create

    Given I want to create resource with the following params:
      | column_id  |
      | 887705     |
    And I pass the following request options:
      | note                   |
      | New Card               |
    When I make request within a cassette named "projects/columns/cards/create_with_note"
    Then the response status should be 201
      And the response type should be JSON
      And the response should not be empty

  Scenario: Create

    Given I want to create resource with the following params:
      | column_id  |
      | 887705     |
    And I pass the following request options:
      | content_id  | content_type |
      | 31901432    | Issue        |
    When I make request within a cassette named "projects/columns/cards/create_with_issue"
    Then the response status should be 201
      And the response type should be JSON
      And the response should not be empty

  Scenario: Update

    Given I want to update resource with the following params:
      | card_id |
      | 2422870 |
    And I pass the following request options:
      | note                   |
      | Updated Card           |
    When I make request within a cassette named "projects/columns/cards/update_with_note"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Update

    Given I want to update resource with the following params:
      | card_id |
      | 2422870 |
    And I pass the following request options:
      | id          | content_type | note                     |
      | 31901432    | Issue        | Updated Second Time Card |
    When I make request within a cassette named "projects/columns/cards/update_with_issue_and_note"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Move

    Given I want to move resource with the following params:
      | card_id |
      | 2448397    |
    And I pass the following request options:
      | position            |
      | after:2422870       |
    When I make request within a cassette named "projects/columns/cards/move"
    Then the response status should be 201
      And the response type should be JSON
      And the response should be empty

  Scenario: Delete

    Given I want to delete resource with the following params:
      | card_id |
      | 2448397    |
    When I make request within a cassette named "projects/columns/cards/delete"
    Then the response status should be 204
      And the response should be empty
