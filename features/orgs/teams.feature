Feature: Members API

  Background:
    Given I have "Github::Client::Orgs::Teams" instance

  Scenario: Add team membership (affiliated user)

    Given I want to add_member resource with the following params:
      | id      | username   |
      | 1799974 | shwetakale |
    When I make request within a cassette named "orgs/teams/add_affiliated_member"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Add team membership (unaffiliated user)

    Given I want to add_member resource with the following params:
      | id      | username    |
      | 1799974 | anujaware   |
    And I pass the following request options:
      | role         |
      | maintainer   |
    When I make request within a cassette named "orgs/teams/add_unaffiliated_member"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Remove team membership (204)

    Given I want to remove_member resource with the following params:
      | id      | username   |
      | 1799974 | shwetakale |
    When I make request within a cassette named "orgs/teams/remove_member"
    Then the response status should be 204
      And the response should be empty