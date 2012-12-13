Feature: Milestones API

  Background:
    Given I have "Github::Issues::Milestones" instance

  Scenario: List

    Given I want to list resources with the following params:
      | user         | repo   |
      | peter-murach | github |
    When I make request within a cassette named "issues/milestones/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should be empty

  Scenario: Get a single milestone

    Given I want to get resource with the following params:
      | user | repo            | milestone_id |
      | josh | rails-behaviors | 1            |
    And I pass the following request options:
      | state  |
      | closed |
    When I make request within a cassette named "issues/milestones/get"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty
