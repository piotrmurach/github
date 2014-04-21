Feature: Markdown API

  Background:
    Given I have "Github::Client::Gitignore" instance

  Scenario: List available templates

    Given I want to list resources
    When I make request within a cassette named "gitignore/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should have 102 items
      And the response should contain Ruby
      And the response should contain Rails

  Scenario: Get a single template

    Given I want to get resource with the following params:
      | template_name |
      | Ruby |
    When I make request within a cassette named "gitignore/get"
    Then the response status should be 200
      And the response type should be JSON
      And the response should have 2 items

  Scenario: Get a raw contents

    Given I want to get resource with the following params:
      | template_name |
      | Ruby          |
    And I pass the following request options:
      | accept                     |
      | application/vnd.github.raw |
    When I make request within a cassette named "gitignore/get_raw"
    Then the response status should be 200
      And the response type should be RAW
      And the response should contain InstalledFiles
