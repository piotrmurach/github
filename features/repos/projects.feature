Feature: Projects API

  Background:
    Given I have "Github::Client::Repos::Projects" instance

  Scenario: List

    Given I want to list resources with the following params:
      | user         | repo           |
      | samphilipd   | github         |
    When I make request within a cassette named "repos/projects/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Create

    Given I want create resource with the following params:
      | user         | repo           |
      | samphilipd   | github         |
    And I pass the following request options:
      | name                   | body                                                    |
      | Projects Documentation | Developer documentation project for the developer site. |
    When I make request within a cassette named "repos/projects/create"
    Then the response status should be 201
      And the response type should be JSON
      And the response should not be empty

