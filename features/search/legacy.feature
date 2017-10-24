Feature: Legacy Search API

  Background:
    Given I have "Github::Client::Search::Legacy" instance

  Scenario: Issues

    Given I want issues resource
      And I pass the following request options:
        | owner        | repo   | state  | keyword |
        | peter-murach | github | closed | api     |
    When I make request within a cassette named "search/legacy/issues"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Repositories

    Given I want repositories resource
      And I pass the following request options:
        | keyword | language | sort  |
        | rails   | ruby     | stars |
    When I make request within a cassette named "search/legacy/repos"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Users

    Given I want users resource
      And I pass the following request options:
        | keyword |
        | wycats  |
    When I make request within a cassette named "search/legacy/users"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Users with complex keyword

    Given I want users resource
      And I pass the following request options:
        | keyword                     |
        | location:Sheffield repos:20 |
    When I make request within a cassette named "search/legacy/users_keyword"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Email

    Given I want email resource
      And I pass the following request options:
        | email            |
        | wycats@gmail.com |
    When I make request within a cassette named "search/legacy/email"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty
