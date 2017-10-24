Feature: Media Type

  Background:
    Given I have "Github::Client::Issues" instance

  Scenario: Default media

    Given I want to get resource with the following params:
      | user          | repo   | issue_id |
      | peter-murach  | github | 108      |
    When I make request within a cassette named "media/get_default"
    Then the response status should be 200
      And the request header Accept should be
      """
      application/vnd.github.v3+json,application/vnd.github.beta+json;q=0.5,application/json;q=0.1
      """

  Scenario: Raw media

    Given I want to get resource with the following params:
      | user          | repo   | issue_id |
      | peter-murach  | github | 108      |
    And I pass the following request options:
      | media |
      | raw   |
    When I make request within a cassette named "media/get_raw_json"
    Then the response status should be 200
      And the request header Accept should be
      """
      application/vnd.github.v3.raw+json
      """

  Scenario: Text media

    Given I want to get resource with the following params:
      | user          | repo   | issue_id |
      | peter-murach  | github | 108      |
    And I pass the following request options:
      | media |
      | text   |
    When I make request within a cassette named "media/get_text_json"
    Then the response status should be 200
      And the request header Accept should be
      """
      application/vnd.github.v3.text+json
      """

  Scenario: Html media

    Given I want to get resource with the following params:
      | user          | repo   | issue_id |
      | peter-murach  | github | 108      |
    And I pass the following request options:
      | media |
      | html   |
    When I make request within a cassette named "media/get_html_json"
    Then the response status should be 200
      And the request header Accept should be
      """
      application/vnd.github.v3.html+json
      """

  Scenario: Full media

    Given I want to get resource with the following params:
      | user          | repo   | issue_id |
      | peter-murach  | github | 108      |
    And I pass the following request options:
      | media     |
      | beta.full |
    When I make request within a cassette named "media/get_full_json"
    Then the response status should be 200
      And the request header Accept should be
      """
      application/vnd.github.beta.full+json
      """
