Feature: Statistics API

  Background:
    Given I have "Github::Client::Repos::Statistics" instance

  Scenario: Contributors

    Given I want contributors resources
      And I pass the following request options:
        | user         | repo   |
        | peter-murach | finite_machine |
    When I make request within a cassette named "repos/stats/contribs"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Commit Activity

    Given I want commit_activity resources
      And I pass the following request options:
        | user         | repo   |
        | peter-murach | tty |
    When I make request within a cassette named "repos/stats/commits"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Code Frequency

    Given I want code_frequency resources
      And I pass the following request options:
        | user         | repo   |
        | peter-murach | github |
    When I make request within a cassette named "repos/stats/frequency"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Participation

    Given I want participation resources
      And I pass the following request options:
        | user         | repo   |
        | peter-murach | finite_machine |
    When I make request within a cassette named "repos/stats/participation"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Punch Card

    Given I want punch_card resources
      And I pass the following request options:
        | user         | repo   |
        | peter-murach | github |
    When I make request within a cassette named "repos/stats/punch"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

