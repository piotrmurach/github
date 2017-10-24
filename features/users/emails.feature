Feature: Accessing Users Emails API

  In order to interact with github user emails
  GithubAPI gem
  Should return the expected results depending on passed parameters

  Background:
    Given I have "Github::Client::Users::Emails" instance

  Scenario: Lists all emails for the authenticated user

    Given I want to list resources
    When I make request within a cassette named "users/emails/all"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Add email addresses for the authenticated user

    Given I want to add resource with the following params:
      | email1              | email2            |
      | octocat@example.com | terry@example.com |
    When I make request within a cassette named "users/emails/add"
    Then the response status should be 201
      And the response type should be JSON
      And the response should have 4 items
      And the response should in email contain octocat@example.com
      And the response should in email contain terry@example.com

  Scenario: Remove email addresses for the authenticated user

    Given I want to add resource with the following params:
      | email1              | email2            |
      | octocat@example.com | terry@example.com |
    And I make request within a cassette named "users/emails/add"
    And I want to delete resource with the following params:
      | email               |
      | octocat@example.com |
    When I make request within a cassette named "users/emails/delete"
    Then the response status should be 204
