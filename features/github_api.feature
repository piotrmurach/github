Feature: Github API components

  In order to interact with full Github API
  A user needs to request a Github class instance

  Scenario: Accessing repositories API
    Given I have github instance
    When  I fetch "repos"
    Then  I will have access to "Github::Repos" API

  Scenario: Accessing organizations API
    Given I have github instance
    When  I fetch "orgs"
    Then  I will have access to "Github::Orgs" API

  Scenario: Accessing gists API
    Given I have github instance
    When  I fetch "gists"
    Then  I will have access to "Github::Gists" API

  Scenario: Accessing issues API
    Given I have github instance
    When  I fetch "issues"
    Then  I will have access to "Github::Issues" API

  Scenario: Accessing pull requests API
    Given I have github instance
    When  I fetch "pull_requests"
    Then  I will have access to "Github::PullRequests" API

  Scenario: Accessing git data API
    Given I have github instance
    When  I fetch "git_data"
    Then  I will have access to "Github::GitData" API

  Scenario: Accessing users API
    Given I have github instance
    When  I fetch "users"
    Then  I will have access to "Github::Users" API

  Scenario: Accessing users API
    Given I have github instance
    When  I fetch "events"
    Then  I will have access to "Github::Events" API

  Scenario: Accessing authorizations API
    Given I have github instance
    When  I fetch "oauth"
    Then  I will have access to "Github::Authorizations" API

