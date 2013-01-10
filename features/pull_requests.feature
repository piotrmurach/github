Feature: Pull Requests API

  Background:
    Given I have "Github::PullRequests" instance

  Scenario: List

    Given I want to list resources with the following params:
      | user          | repo   |
      | peter-murach  | github |
      And I pass the following request options:
        | state  |
        | closed |
    When I make request within a cassette named "pull_requests/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Get

    Given I want to get resource with the following params:
      | user          | repo   | number |
      | peter-murach  | github | 36     |
    When I make request within a cassette named "pull_requests/get"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty
