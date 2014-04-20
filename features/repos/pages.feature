Feature: Pages API

  Background:
    Given I have "Github::Client::Repos::Pages" instance

  Scenario: List builds

    Given I want to list resources with the following params:
      | owner | repo            |
      | murek | github_api_test |
    When I make request within a cassette named "repos/pages/list_builds"
    Then the response status should be 200
      And the response type should be JSON
      And the response should be empty

  Scenario: Get

    Given I want to get resource with the following params:
      | owner | repo            |
      | murek | github_api_test |
    When I make request within a cassette named "repos/pages/get"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty
