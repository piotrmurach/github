Feature: Accessing Gists Comments API
  In order to interact with github gist comments
  GithubAPI gem
  Should return the expected results depending on passed parameters

  Background:
    Given I have "Github::Client::Gists::Comments" instance

  Scenario: Lists comments on a gist
    When I want to list resources with the following params:
      | gist_id |
      | 701407  |
      And I make request within a cassette named "gists/comments/all"
    Then the response status should be 200
      And the response type should be JSON
      And the response should have 30 items

  Scenario: Gets a single gist's comment
    When I want to get resource with the following params:
      | gist_id | comment_id |
      | 701407  | 66128      |
    And I make request within a cassette named "gists/comments/first"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty
