Feature: Accessing GitData References API

  In order to interact with github git data references
  GithubAPI gem
  Should return the expected results depending on passed parameters

  Background:
    Given I have "Github::Client::GitData::References" instance

  Scenario: Lists all references on a repository
    Given I want to list resources with the following params:
      | user         | repo           |
      | peter-murach | finite_machine |
    When I make request within a cassette named "git_data/references/all"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Lists all references on a repository scoped by branch
    Given I want to list resources with the following params:
      | user         | repo           |
      | peter-murach | finite_machine |
    And I pass the following request options:
      | ref  |
      | tags |
    When I make request within a cassette named "git_data/references/all_tags"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Gets a single reference
    Given I want to get resource with the following params:
      | user         | repo | ref            |
      | peter-murach | tty  | heads/gh-pages |
    When I make request within a cassette named "git_data/references/one"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

#   Scenario: Create a reference
#     Given I want to create resource with the following params:
#       | user  | repo            |
#       | murek | github_api_test |
#     And I pass the following request options:
#       | ref               | sha                                      |
#       | refs/heads/master | 827efc6d56897b048c772eb4087f854f46256132 |
#     When I make request within a cassette named "git_data/references/create"
#     Then the response should be "200"
#       And the response type should be "JSON"
