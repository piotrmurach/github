Feature: Accessing Gists Comments API
  In order to interact with github gist comments
  GithubAPI gem
  Should return the expected results depending on passed parameters

  Background:
    Given I have "Github::Gists" instance

  Scenario: Lists comments on a gist
    When I am looking for "comments" with the following params:
      | gist_id |
      | 999390  |
      And I make request within a cassette named "gists/comments/all"
    Then the response should be "200"
      And the response type should be "JSON"
      And the response should have 18 items

  Scenario: Gets a single gist's comment
    When I am looking for "comment" with the following params:
      | comment_id |
      | 33469      |
    And I make request within a cassette named "gists/comments/first"
    Then the response should be "200"
      And the response type should be "JSON"
      And the response should not be empty
