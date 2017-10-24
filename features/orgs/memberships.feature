Feature: Memberships API

  Background:
    Given I have "Github::Client::Orgs::Memberships" instance

  Scenario: List

    Given I want to list resources
    When I make request within a cassette named "orgs/memberships/list"
    Then the response status should be 200
      And the response type should be JSON

  Scenario: Get organization membership

    Given I want to get resource with the following params:
      | org   |
      | rails |
    And I pass the following request options:
      | username     |
      | peter-murach |
    When I make request within a cassette named "orgs/memberships/get"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Add/Update Organization Membership (unaffiliated user)

    Given I want to create resource with the following params:
      | org    | username  |
      | CodeCu | anujaware |
    And I pass the following request options:
      | role   |
      | member |
    When I make request within a cassette named "orgs/memberships/add_unaffiliated_user"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Add/Update Organization Membership (already member)

    Given I want to create resource with the following params:
      | org    | username    |
      | CodeCu | anuja-joshi |
    And I pass the following request options:
      | role   |
      | admin  |
    When I make request within a cassette named "orgs/memberships/add_already_member"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty
