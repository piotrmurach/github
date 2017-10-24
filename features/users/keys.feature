Feature: Accessing Users Keys API

  In order to interact with github user keys
  GithubAPI gem
  Should return the expected results depending on passed parameters

  Background:
    Given I have "Github::Client::Users::Keys" instance

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

  Scenario: Create

    Given I want to create resource with the following params:
      | user   | repo            |
      | murek  | github_api_test |
    And I pass the following request options:
      | title       | key                                              |
      | Found a bug | ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7ZihX0HkqN1m/m7Ae7xHJwewg8Nimpmsy6lgt32IphOh0JDx1ssiWTXUWP77Lj3VR6Y2oNbMguaf2sn+n4oTcojbJXuqj8zd16NqYOu7kJlCUIKpTgX+IvmO6XMZddd1Lq8LLIQMZRG7j3/6agDDWR6retmT4JOSCmbBEomoVP0NHPlL6XK5WlF05+6ssxbL9s8uD5q1QvlkjVuFSjWSdYM+IBgNFtw8kJwoKL+eadL4So/xTk+yBUAMUTPO+02mQ2VJ5R06mgSny3omalS3cym4KR4uwENABhk0drxG78rvpMNfjcvT9llRJ+FI8lVgQOI0729z+1ApiWgzEQsK3 |
    When I make request within a cassette named "users/keys/create"
    Then the response status should be 201
      And the response type should be JSON
      And the response should not be empty

  Scenario: Delete
    Given I want to delete resource with the following params:
      | id      |
      | 8715940 |
    When I make request within a cassette named "users/keys/delete"
    Then the response status should be 204
      And the response should be empty
