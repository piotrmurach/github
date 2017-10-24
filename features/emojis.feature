Feature: Emojis API

  Background:
    Given I have "Github::Client::Emojis" instance

  Scenario: List

    Given I want to list resources
    When I make request within a cassette named "emojis/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty
