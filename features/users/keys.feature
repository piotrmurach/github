Feature: Accessing Users Keys API

  In order to interact with github user keys
  GithubAPI gem
  Should return the expected results depending on passed parameters

  Background:
    Given I have "Github::Users::Keys" instance

  Scenario: Lists all public keys for a user

    Given I want to list resources
      And I pass the following request options:
        | user   |
        | wycats |
    When I make request within a cassette named "users/keys/user_all"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Lists all public keys for the authenticted user

    Given I want to list resources
    When I make request within a cassette named "users/keys/user"
    Then the response status should be 200
      And the response type should be JSON
      And the response should be empty
