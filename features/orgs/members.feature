Feature: Members API

  Background:
    Given I have "Github::Client::Orgs::Members" instance

  Scenario: List

    Given I want to list resources with the following params:
      | org   |
      | rails |
    When I make request within a cassette named "orgs/members/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: List Public

    Given I want to list resources with the following params:
      | org   |
      | rails |
    And I pass the following request options:
      | public |
      | true   |
    When I make request within a cassette named "orgs/members/list_public"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Check if member of organization (302)

    Given I want to member? resource with the following params:
      | org   | member |
      | rails | drogus |
    When I make request within a cassette named "orgs/members/member_false"
    Then the response should be false

  Scenario: Check if public member of organization (404)

    Given I want to member? resource with the following params:
      | org   | member       |
      | rails | peter-murach |
    And I pass the following request options:
      | public |
      | true   |
    When I make request within a cassette named "orgs/members/member_public_false"
    Then the response should be false

  Scenario: Check if public member of organization (204)

    Given I want to member? resource with the following params:
      | org   | member |
      | rails | drogus |
    And I pass the following request options:
      | public |
      | true   |
    When I make request within a cassette named "orgs/members/member_public_true"
    Then the response should be true
