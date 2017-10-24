Feature: Handles HTTP error codes

  In order to handle error cases accordingly
  As a developer
  I want to be informed of non-successful responses

  Scenario: A response of '401 - Unauthorised access'
    Given I have "Github::Client::Repos" instance
    And I am not authorized
    When I want to create resource
      And I pass the following request options:
        | name       |
        | basic_auth |
    Then request should fail with "Github::Error::Unauthorized" within a cassette named "errors/repos/create"
