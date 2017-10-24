Feature: Pull Requests API

  Background:
    Given I have "Github::Client::PullRequests" instance

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

  Scenario: Create

    Given I want to create resource with the following params:
      | user   | repo            |
      | murek  | github_api_test |
    And I pass the following request options:
      | title       | body                | base | head |
      | Found a bug | Im having a problem | master| murek:gh-pages |
    When I make request within a cassette named "pull_requests/create"
    Then the response status should be 201
      And the response type should be JSON
      And the response should not be empty

  Scenario: Merged?

    Given I want to merged? resource with the following params:
      | user   | repo            | number |
      | murek  | github_api_test | 4      |
    When I make request within a cassette named "pull_requests/merged"
    Then the response should be false

  Scenario: Merge

    Given I want to merge resource with the following params:
      | user   | repo            | number |
      | murek  | github_api_test | 4      |
    And I pass the following request options:
      | commit_message     |
      | Fixing a major bug |
    When I make request within a cassette named "pull_requests/merge"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

