Feature: Projects API

  Background:
    Given I have "Github::Client::Projects" instance

  Scenario: Get

    Given I want to get resource with the following params:
      | id     |
      | 524103 |
    When I make request within a cassette named "projects/get"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Edit

    Given I want to edit resource with the following params:
      | id     |
      | 524103 |
    And I pass the following request options:
      | name                   | body                                                  |
      | Outcomes Tracker       | The board to track work for the Outcomes application. |
    When I make request within a cassette named "projects/edit"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Delete a Project

    Given I want delete resource with the following params:
      | id     |
      | 524103 |
    When I make request within a cassette named "projects/delete"
    Then the response status should be 204
      And the response should be empty
