Feature: Emojis API

  Background:
    Given I have "Github::Client::Meta" instance

  Scenario: Get

    Given I want to get resources
    When I make request within a cassette named "meta/get"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty
