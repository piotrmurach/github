Feature: Github API components

  In order to navigate within Github API hierachy
  A user
  I want to be able to with a given Github API instance

  Scenario: Accessing repositories API
    Given I have github instance
    When  I fetch "repos"
    Then  I will have access to "Github::Repos" API

  Scenario: Accessing organizations API
    Given I have github instance
    When  I fetch "orgs"
    Then  I will have access to "Github::Orgs" API

  Scenario: Accessing members API
    Given I have "Github::Orgs" instance
    When  I call members
    Then  I will have access to "Github::Orgs::Members" API

  Scenario: Accessing teams API
    Given I have "Github::Orgs" instance
    When  I call teams
    Then  I will have access to "Github::Orgs::Teams" API

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

  Scenario: Accessing activity API
    Given I have github instance
    When  I fetch "activity"
    Then  I will have access to "Github::Activity" API

  Scenario: Accessing authorizations API
    Given I have github instance
    When  I fetch "oauth"
    Then  I will have access to "Github::Authorizations" API

