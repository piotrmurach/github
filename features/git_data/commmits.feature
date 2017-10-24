Feature: GitData Commits API

  Background:
    Given I have "Github::Client::GitData::Commits" instance

  Scenario: Gets a single commit

    Given I want to get resource with the following params:
      | user  | repo   | sha                                      |
      | boyan | github | aca2a25d442a9545b01f42574c46f59035993b02 |
    When I make request within a cassette named "git_data/commits/get"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty
