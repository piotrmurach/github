Feature: Tags API

  Background:
    Given I have "Github::Client::Repos::Releases::Tags" instance

  Scenario: Get a published release with

    Given I want to get resource with the following params:
      | owner          | repo          | tag |
      | anuja-joshi    | rails_express | v1  |
    When I make request within a cassette named "repos/releases/tags"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty
