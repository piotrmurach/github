Feature: Comments API

  Background:
    Given I have "Github::Client::Repos::Comments" instance

  Scenario: List

    Given I want to list resources with the following params:
      | user  | repo |
      | peter-murach | finite_machine |
    When I make request within a cassette named "repos/comments/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should be empty
