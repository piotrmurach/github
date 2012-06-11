Feature: Contents API

  Background:
    Given I have "Github::Repos::Contents" instance

  Scenario: Readme

    Given I want readme resource with the following params:
      | user         | repo   |
      | peter-murach | github |
    When I make request within a cassette named "repos/contents/readme"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Get file contents

    Given I want get resource with the following params:
      | user         | repo   | path      |
      | peter-murach | github | README.md |
    When I make request within a cassette named "repos/contents/get"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Archive

    Given I want archive resource with the following params:
      | user         | repo   |
      | peter-murach | github |
    And I pass the following request options:
      | archive_format | ref    |
      | tarball        | master |
    When I make request within a cassette named "repos/contents/archive"
    Then the response status should be 302
