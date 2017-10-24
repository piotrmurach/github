Feature: Deploy Keys API

  Background:
    Given I have "Github::Client::Repos::Keys" instance

  Scenario: List

    Given I want to list resources with the following params:
      | owner | repo            |
      | murek | github_api_test |
    When I make request within a cassette named "repos/keys/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Get

    Given I want to get resource with the following params:
      | owner | repo            | id       |
      | murek | github_api_test | 14673755 |
    When I make request within a cassette named "repos/keys/get"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Create

    Given I want to create resource with the following params:
      | owner | repo            |
      | murek | github_api_test |
      And I pass the following request options:
        | title    | key          | read_only |
        | precious | ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEYYXMueLd5fffInOTrhCaoTYXdjKw4Ei+ONsxxD6Mvjl+Z0vbQVmwMCtwIWPjgxJPX1Wsozym1bnSkGn2kjatOewovqWBZpgC9HpkR7RytEnVl/tb6kHo9AvBID9OYF7zk7JrRpPxYHVu6g/GqARFAAGXxX+qCgXdjo/QepArh9VL4GIR9SxBFWmTT/tmLahBIG7sGlNrkFJjrvaKLuaFbMgQ2HAi4cIbTmt0kGOx0AEZudJLZOS1gwaI74V0wK5K7zIvZw/sg49SLvjnBEiFk1fq4SJdSSXw2UDFq9hb6nYU/S9Ufqy+5VROfSyE6W/ugsy8kBHUQmllpKJ5VySx | true      |
    When I make request within a cassette named "repos/keys/create"
    Then the response status should be 201
      And the response type should be JSON
      And the response should not be empty

  Scenario: Delete

    Given I want to delete resource with the following params:
      | owner | repo            | id       |
      | murek | github_api_test | 14673755 |
    When I make request within a cassette named "repos/keys/delete"
    Then the response status should be 204
