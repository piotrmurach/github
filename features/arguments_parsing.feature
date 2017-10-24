Feature: Github API arguments parsing

  The gem permits flexible arguments parsing, which means, the arguments can 
  be passed in as values or named hash key parameters. Properties are dynamically
  assigned when executing requests.

  Scenario: Invoking multiple calls for organization information

    Given I have "Github::Client::Orgs" instance
    When I want to get resource with the following arguments:
      | org        |
      | thoughtbot |
      And I make request within a cassette named "arguments/orgs/get"
      And I make request within a cassette named "arguments/orgs/get"
    Then the response status should be 200

  Scenario: Invoking multiple calls for repository commits

    Given I have "Github::Client::Repos::Commits" instance
    When I want to get resource with the following arguments:
      | user     | repo     | sha                                      |
      | rubinius | rubinius | 7ac2bd74e8b6f16362fb3b7e6f3d139c48bb1c12 |
      And I make request within a cassette named "arguments/repo_commits/get"
      And I make request within a cassette named "arguments/repo_commits/get"
    Then the response status should be 200

  Scenario: Invoking multiple calls for fetching pull request

    Given I have "Github::Client::PullRequests" instance
    When I want to get resource with the following arguments:
      | user     | repo     | number |
      | rubinius | rubinius | 2193   |
      And I make request within a cassette named "arguments/pulls/get"
      And I make request within a cassette named "arguments/pulls/get"
    Then the response status should be 200
