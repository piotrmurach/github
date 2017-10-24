Feature: User Followers API

  Background:
    Given I have "Github::Client::Users::Followers" instance

  Scenario: List a user's followers

    Given I want to list resources with the following params:
      | username     |
      | peter-murach |
    When I make request within a cassette named "users/followers/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: List who a user is following

    Given I want to following resources with the following params:
      | username     |
      | peter-murach |
    When I make request within a cassette named "users/followers/following"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Follow a user

    Given I want to follow resource
      And I pass the following request options:
        | username |
        | wycats   |
    When I make request within a cassette named "users/followers/follow"
    Then the response status should be 204
      And the response should be empty

  Scenario: Check if you are following a user

    Given I want to following? resource
      And I pass the following request options:
        | username |
        | wycats   |
    When I make request within a cassette named "users/followers/following?"
    Then the response should be true

  Scenario: Check if one user follows another

    Given I want to following? resource
      And I pass the following request options:
        | username | target_user |
        | wycats   | rsutphin    |
    When I make request within a cassette named "users/followers/following?another"
    Then the response should be true

  Scenario: Unfollow a user

    Given I want to unfollow resource
      And I pass the following request options:
        | username |
        | wycats   |
    When I make request within a cassette named "users/followers/unfollow"
    Then the response status should be 204
      And the response should be empty

