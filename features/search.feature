Feature: Search API

  Background:
    Given I have "Github::Client::Search" instance

  Scenario: Issues

    Given I want issues resource
      And I pass the following request options:
        | q   | sort    |
        | tty | created |
    When I make request within a cassette named "search/issues"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Repositories

    Given I want repositories resource
      And I pass the following request options:
        | q     | sort    |
        | rails | created |
    When I make request within a cassette named "search/repos"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Users

    Given I want users resource
      And I pass the following request options:
        | q      |
        | wycats |
    When I make request within a cassette named "search/users"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Users with search parameters

    Given I want users resource
      And I pass the following request options:
        | q                           |
        | location:Sheffield repos:20 |
    When I make request within a cassette named "search/users_keyword"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Code

    Given I want code resource
      And I pass the following request options:
        | q                     | sort    |
        | user:peter-murach tty | indexed |
    When I make request within a cassette named "search/code"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Code with search paramters

    Given I want code resource
      And I pass the following request options:
        | q                                               | sort    |
        | TTY in:file language:ruby repo:peter-murach/tty | indexed |
    When I make request within a cassette named "search/code_query"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Code with unicode characters

    Given I want code resource
      And I pass the following request options:
        | q                                        | sort    |
        | Gemfile in:path repo:peter-murach/github | indexed |
    When I make request within a cassette named "search/code_unicode"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

