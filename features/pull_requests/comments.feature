Feature: Pull Requests Comments API

  Background:
    Given I have "Github::Client::PullRequests::Comments" instance

  Scenario: List in a repository

    Given I want to list resources with the following params:
      | user          | repo   |
      | peter-murach  | github |
    When I make request within a cassette named "pull_requests/comments/list_repo"
    Then the response status should be 200
      And the response type should be JSON
      And the response should have 4 items

  Scenario: List on a pull request

    Given I want to list resources with the following params:
      | user          | repo   |
      | peter-murach  | github |
      And I pass the following request options:
        | number |
        | 62     |
    When I make request within a cassette named "pull_requests/comments/list_pull"
    Then the response status should be 200
      And the response type should be JSON
      And the response should have 0 items
